import router from '@ohos.router'
import { McLineChart, Options } from '@mcui/mccharts'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'

let thresholdPM: number = 0
let thresholdNoise: number = 0
let thresholdAgriculture: number = 0

interface ShadowProperties {
  PM2_5?: number
  pm2_5_data?: number
  NoiseStatus?: number
  NoiseVolume?: number
  Threshold?: number
  Temperature?: number
  Humidity?: number
}

interface ShadowReported {
  properties?: ShadowProperties
  event_time?: string
}

interface ShadowItem {
  service_id?: string
  desired?: object
  reported?: ShadowReported
  version?: number
}

interface ShadowResponse {
  device_id?: string
  shadow: ShadowItem[]
}

class Item{
  name1:string
  name2:string
  name3:string

  constructor(name1:string,name2:string,name3:string) {
    this.name1=name1
    this.name2=name2
    this.name3=name3
  }
}

@Entry
@Component
struct baojing {
  @State noisemodule: noiseModule = new noiseModule()
  @State pmmodule: pmModule = new pmModule()
  @State agriculturemodule: agriculture = new agriculture()
  @State debuglog: debugLog = new debugLog()
  @State temperature: number = 0
  @State humidity: number = 0


  private item1:Array<Item> = [
    new Item('温度低于40摄氏度','良好',' 厂区二'),
    new Item('温度超出42.1摄氏度','重度',' 厂区一'),
    new Item('空气湿度低于10%','良好',' 厂区三'),
    new Item('温度超出42.1摄氏度','重度',' 厂区二'),
    new Item('温度低于30摄氏度','优级',' 厂区一'),
    new Item('空气湿度超过15%','重度',' 厂区一'),
    new Item('温度低于40摄氏度','良好',' 厂区三'),
    new Item('空气湿度低于5%','优级',' 厂区一'),
    new Item('温度低于40摄氏度','良好',' 厂区二'),
    new Item('温度超出42.1摄氏度','重度','厂区三'),
    new Item('温度低于30摄氏度','优级',' 厂区一'),
    new Item('空气湿度超过15%','重度',' 厂区二'),
    new Item('温度低于40摄氏度','良好',' 厂区一'),
    new Item('空气湿度低于5%','优级',' 厂区三'),
    new Item('温度低于40摄氏度','良好',' 厂区一')

  ]

  private item2:Array<Item> = [
    new Item('设备A','良好',' D区域'),
    new Item('设备F','重度',' E区域'),
    new Item('设备E','良好',' B区域'),
    new Item('设备D','重度',' C区域'),
    new Item('设备A','优级',' A区域'),
    new Item('设备B','重度',' E区域'),
    new Item('设备D','良好',' D区域'),
    new Item('设备E','优级',' E区域'),
    new Item('设备A','良好',' D区域'),
    new Item('设备D','重度',' C区域'),
    new Item('设备C','优级',' A区域'),
    new Item('设备F','重度',' E区域'),
    new Item('设备B','良好',' D区域'),
    new Item('设备E','优级',' A区域'),
    new Item('设备D','良好',' D区域')

  ]

  build(){
    Column(){
      //顶端
      Row(){
        Image($r('app.media.a'))
          .onClick(()=>{
            router.back()
          })
          .width(40)
        Text('告警列示')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({left:75})
        Image($r('app.media.b'))
          .width(40)
          .margin({left:75})
          .onClick(()=>{
            router.push({url:'pages/tongzhi'})
          })
      }
      .width('98%')
      .height(50)
      //
      Tabs({barPosition: BarPosition.Start }){
        TabContent(){
          Column(){
            //实时数据
            Column(){
              Row(){
                Text('实时数据')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({top:10})
              }
              .width('90%')
              /* .onClick(()=>{
                 router.pushUrl({url:'pages/ChangQu'})
               })*/

              Row(){
                Column({space:10}){
                  Text(this.pmmodule.PM25Data+' ')
                    .fontSize(20)
                  Text('PM2.5')
                    .fontSize(20)
                    .fontWeight(600)
                    .fontColor(Color.Gray)
                }
                .width('25%')
                .height('60%')
                Column({space:10}){
                  Text('' + this.noisemodule.NoiseVolume)
                    .fontSize(20)
                  Text('噪音')
                    .fontSize(20)
                    .fontWeight(600)
                    .fontColor(Color.Gray)
                }
                .width('25%')
                .height('60%')
                Column({space:10}){
                  Text('' + this.temperature)
                    .fontSize(20)
                  Text('温度')
                    .fontSize(20)
                    .fontWeight(600)
                    .fontColor(Color.Gray)
                }
                .width('25%')
                .height('60%')
                Column({space:10}){
                  Text('' + this.humidity)
                    .fontSize(20)
                  Text('湿度')
                    .fontSize(20)
                    .fontWeight(600)
                    .fontColor(Color.Gray)
                }
                .width('25%')
                .height('60%')

              }
              .width('100%')
              .height(80)
            }
            .width('90%')
            .backgroundColor('white')
            .borderRadius(30)
            .margin({top:15})
            //区域环境
            Column(){
              Row(){
                Text('区域环境')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({top:10})
              }
              .width('90%')
              Row(){
                Text('环境监测')
                  .fontSize(20)
                  .fontColor('#bfbfbf')
                  .width('33.33%')
                  .textAlign(TextAlign.Center)
                Text('等级')
                  .fontSize(20)
                  .fontColor('#bfbfbf')
                  .width('33.33%')
                  .margin({left:35})
                Text('区域')
                  .fontSize(20)
                  .fontColor('#bfbfbf')
                  .width('33.33%')
                  .margin({left:10})
              }
              .width('90%')
              .margin({top:10})

              List({space:8}){
                ForEach(
                  this.item1,
                  (item:Item)=> {
                    ListItem(){
                      Row(){
                        Text(item.name1)
                          .width('45%')
                          .fontSize(15)
                          .margin({left:10})
                        Text(item.name2)
                          .width('15%')
                          .fontSize(15)
                        Text(item.name3)
                          .width('40%')
                          .fontSize(15)
                          .margin({left:50})
                      }
                      .width('98%')
                      .height(40)
                      .borderColor('#e6e6e6')
                      .borderWidth({bottom:1})
                      .onClick(()=>{
                        router.pushUrl({url:'pages/XiangQingYe'})
                      })
                    }
                  }
                )
              }
              .height(230)
              .width('98%')
              .layoutWeight(0)

            }

            .width('90%')
            .height(300)
            .backgroundColor('white')
            .borderRadius(30)
            .margin({top:30})
            //告警
            Row() {
              Column() {
                Image($r('app.media.c'))
                  .width(50)
                  .height(50)
              }
              .width('15%')
              .margin({ left: '10' })

              Column() {
                Text('23')
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#19aba8')
                Text('未处理告警')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('red')
                  .margin({ top: '5' })
              }
              .width('25%')
              .onClick(()=>{
                router.push({url:'pages/gaojing'})
              })

              Column() {
                Image($r('app.media.d'))
                  .width(40)
                  .height(40)
              }
              .width('15%')
              .margin({ left: '40' })

              Column() {
                Text('33')
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#19aba8')
                Text('已处理告警')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#bfbfbf')
                  .margin({ top: '5' })
              }
              .width('25%')
              .onClick(()=>{
                router.push({url:'pages/gaojing2'})
              })
            }
            .width('100%')
            .height(100)
            .margin({top :20})

          }
          .width('100%')
          .height('100%')
        }
        .tabBar('环境异常列表')

        TabContent(){
          Column(){
            //运转数量
            Column(){
              Row(){
                Text('运转数量')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .margin({top:10})
                  .width('30%')
                Image($r('app.media.j2'))
                  .width(25)
                  .height(20)
                  .margin({top:5,left:45})
                Text('正常')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#bfbfbf')
                  .margin({top:5})

                Image($r('app.media.j1'))
                  .width(25)
                  .height(20)
                  .margin({top:5})
                Text('待工')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#bfbfbf')
                  .margin({top:5})

                Image($r('app.media.j'))
                  .width(25)
                  .height(20)
                  .margin({top:5})
                Text('故障')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#bfbfbf')
                  .margin({top:5})
              }
              .width('95%')
              Row(){
                Column(){
                  Stack(){
                    Progress({value:65,total:100,type:ProgressType.Ring})
                    Text('45')
                      .fontSize(22)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#bfbfbf')
                  }
                }
                .width('33.33%')
                .margin({top:10})

                Column(){
                  Stack(){
                    Progress({value:25,total:100,type:ProgressType.Ring})
                      .color('#e98f36')
                    Text('4')
                      .fontSize(22)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#bfbfbf')
                  }
                }
                .width('33.33%')
                .margin({top:10})

                Column(){
                  Stack(){
                    Progress({value:10,total:100,type:ProgressType.Ring})
                      .color('#e55b4b')
                    Text('1')
                      .fontSize(22)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#bfbfbf')
                  }
                }
                .width('33.33%')
                .margin({top:10})
              }
            }
            .width('90%')
            .height(130)
            .backgroundColor('white')
            .borderRadius(30)
            .margin({top:15})
            //故障数据
            Column(){
              Row(){
                Text('故障数据')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({top:10})
              }
              .width('90%')
              Row(){
                Text('设备名称')
                  .fontSize(20)
                  .fontColor('#bfbfbf')
                  .width('33.33%')
                  .textAlign(TextAlign.Center)
                Text('运转状态')
                  .fontSize(20)
                  .fontColor('#bfbfbf')
                  .width('33.33%')
                  .margin({left:35})
                Text('区域')
                  .fontSize(20)
                  .fontColor('#bfbfbf')
                  .width('33.33%')
                  .margin({left:10})
              }
              .width('90%')
              .margin({top:10})

              List({space:8}){
                ForEach(
                  this.item2,
                  (item:Item)=> {
                    ListItem(){
                      Row(){
                        Text(item.name1)
                          .width('45%')
                          .fontSize(15)
                          .margin({left:10})
                        Text(item.name2)
                          .width('15%')
                          .fontSize(15)
                          .margin({left:15})
                        Text(item.name3)
                          .width('40%')
                          .fontSize(15)
                          .margin({left:35})
                      }
                      .width('98%')
                      .height(40)
                      .borderColor('#e6e6e6')
                      .borderWidth({bottom:1})
                    }
                  }
                )
              }
              .width('98%')
              .layoutWeight(0)

            }
            .width('90%')
            .height(300)
            .backgroundColor('white')
            .borderRadius(30)
            .margin({top:30})

            Row(){
              Image($r('app.media.j2'))
                .width(30)
              Text('请前往控制系统进行处理 >>')
                .fontColor('blue')
            }
            .width('100%')
            .height(50)
            .margin({top:150,left:250})
            .onClick(()=>{
              router.push({url:'pages/kongzhi'})
            })
          }
          .width('100%')
          .height('100%')
        }
        .tabBar('生产异常列表')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'100%'})
  }

  getNoiseData() {
    let HttpRequest = http.createHttp()
    let url = 'https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676f5798ef99673c8ada2618_NoiseDetection/shadow'
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "X-Auth-Token": "MIIN0AYJKoZIhvcNAQcCoIINwTCCDb0CAQExDTALBglghkgBZQMEAgEwggviBgkqhkiG9w0BBwGgggvTBIILz3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDI6MjU6MjUuMDQzMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiY2F0YWxvZyI6W10sInJvbGVzIjpbeyJuYW1lIjoidGVfYWRtaW4iLCJpZCI6IjAifSx7Im5hbWUiOiJ0ZV9hZ2VuY3kiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3JlcF9hY2NlbGVyYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZGlza0FjYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rzc19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRoLTRjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZGVjX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vbGRfcmVvdXJjZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19Sb3lhbHR5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfd2VsaW5rYnJpZGdlX2VuZHBvaW50X2J1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLXJvY2tldG1xNS1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1rYWZrYTMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX3Ztd2FyZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2lkbWVfbWJtX2ZvdW5kYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYzZhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9jYWxsbm90aWZ5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtM2QiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2tvb21hcCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19lc3NkMiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1hbXFwLWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3Bvb2xfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRod2VzdC0yYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3Y3BoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfaGVjc194IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGVzX2JhY2t1cCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lcHMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmVfYWxsIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX3JvdW5kdGFibGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXh0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcGZzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1tb3Njb3ctMWIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FwcHN0YWdlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fYXBwbGljYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfY29sZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Jkc19jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19ncHVfZzVyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfbWVzc2FnZW92ZXI1ZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19yaSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbm9ydGh3ZXN0LTJjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWVmX3BsYXRpbnVtIiwiaWQiOiIwIn1dLCJwcm9qZWN0Ijp7ImRvbWFpbiI6eyJuYW1lIjoiemhyMTY4LSIsImlkIjoiZWE2NmI4MjUyNDQxNGZhZWE0ODlhMWNkMGE4OWQ2OTAifSwibmFtZSI6ImNuLW5vcnRoLTQiLCJpZCI6ImQyNDM0OGFkZDVjYjQ1YTBhNjNlZWU1NjM2NDU0NWEwIn0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDI6MjU6MjUuMDQzMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBPsHXrn6Z+ka24gxIgQgfx2V85C0+CELCnuKGwrCDxGhiTLQiKDD8plG8HmLkTzxCmajyHvs5YxlQAru7nLW2kFe2ZaGgEgDkNeaT1xr6-kw7PEf3jnFAEat2soPINmnbdCloS1n2fgUcd4HhSRYDyKd+5PsvFKuW0tiIYAQ3vcKVpRsxE5iUWsl1j-x3hNKsr+ReZ4xCT1sOas4JZ-V9nqj9f28+QK611jksKp9C3yYXn4kFTl58R745qP4Orekv4AkwclbT37gZ9a2EtlhUtJr5dVuD14KG+TUK02kW2yKonJiWZ-0sa-qshmWjzz55fvz+dId0XeBiW+PlsNTJX", // 请替换为有效Token
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          const data = JSON.parse(response.result.toString()) as ShadowResponse;
          const props = data.shadow?.[0]?.reported?.properties;
          if (props && typeof props.NoiseVolume === 'number') {
            this.noisemodule.NoiseVolume = Number(props.NoiseVolume.toFixed(2));
            this.noisemodule.Threshold = props.Threshold ?? 0;
            console.info('成功获取噪音数据:', this.noisemodule.NoiseVolume);
          } else {
            console.info('设备影子数据中没有找到噪音数据');
          }
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
        }
      }
    })
  }

  getPmData() {
    let HttpRequest = http.createHttp();
    let url = 'http://192.168.18.129:5000/pm25_data';
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "X-Auth-Token": "MIIN0AYJKoZIhvcNAQcCoIINwTCCDb0CAQExDTALBglghkgBZQMEAgEwggviBgkqhkiG9w0BBwGgggvTBIILz3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDI6MjU6MjUuMDQzMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiY2F0YWxvZyI6W10sInJvbGVzIjpbeyJuYW1lIjoidGVfYWRtaW4iLCJpZCI6IjAifSx7Im5hbWUiOiJ0ZV9hZ2VuY3kiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3JlcF9hY2NlbGVyYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZGlza0FjYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rzc19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRoLTRjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZGVjX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vbGRfcmVvdXJjZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19Sb3lhbHR5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfd2VsaW5rYnJpZGdlX2VuZHBvaW50X2J1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLXJvY2tldG1xNS1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1rYWZrYTMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX3Ztd2FyZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2lkbWVfbWJtX2ZvdW5kYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYzZhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9jYWxsbm90aWZ5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtM2QiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2tvb21hcCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19lc3NkMiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1hbXFwLWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3Bvb2xfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRod2VzdC0yYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3Y3BoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfaGVjc194IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGVzX2JhY2t1cCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lcHMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmVfYWxsIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX3JvdW5kdGFibGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXh0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcGZzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1tb3Njb3ctMWIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FwcHN0YWdlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fYXBwbGljYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfY29sZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Jkc19jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19ncHVfZzVyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfbWVzc2FnZW92ZXI1ZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19yaSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbm9ydGh3ZXN0LTJjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWVmX3BsYXRpbnVtIiwiaWQiOiIwIn1dLCJwcm9qZWN0Ijp7ImRvbWFpbiI6eyJuYW1lIjoiemhyMTY4LSIsImlkIjoiZWE2NmI4MjUyNDQxNGZhZWE0ODlhMWNkMGE4OWQ2OTAifSwibmFtZSI6ImNuLW5vcnRoLTQiLCJpZCI6ImQyNDM0OGFkZDVjYjQ1YTBhNjNlZWU1NjM2NDU0NWEwIn0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDI6MjU6MjUuMDQzMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBPsHXrn6Z+ka24gxIgQgfx2V85C0+CELCnuKGwrCDxGhiTLQiKDD8plG8HmLkTzxCmajyHvs5YxlQAru7nLW2kFe2ZaGgEgDkNeaT1xr6-kw7PEf3jnFAEat2soPINmnbdCloS1n2fgUcd4HhSRYDyKd+5PsvFKuW0tiIYAQ3vcKVpRsxE5iUWsl1j-x3hNKsr+ReZ4xCT1sOas4JZ-V9nqj9f28+QK611jksKp9C3yYXn4kFTl58R745qP4Orekv4AkwclbT37gZ9a2EtlhUtJr5dVuD14KG+TUK02kW2yKonJiWZ-0sa-qshmWjzz55fvz+dId0XeBiW+PlsNTJX", // 请替换为有效Token
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          const parsedData = JSON.parse(response.result.toString()) as pmModule;
          this.pmmodule = parsedData;
          console.info('pmmodule:' + JSON.stringify(this.pmmodule));
          thresholdPM = this.pmmodule.Threshold;
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
        }
      }
    });
  }

  getagricultureData() {
    let HttpRequest = http.createHttp();
    let url = 'http://192.168.1.172:5001/agriculture_data';
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "X-Auth-Token": "MIIN0AYJKoZIhvcNAQcCoIINwTCCDb0CAQExDTALBglghkgBZQMEAgEwggviBgkqhkiG9w0BBwGgggvTBIILz3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDI6MjU6MjUuMDQzMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiY2F0YWxvZyI6W10sInJvbGVzIjpbeyJuYW1lIjoidGVfYWRtaW4iLCJpZCI6IjAifSx7Im5hbWUiOiJ0ZV9hZ2VuY3kiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3JlcF9hY2NlbGVyYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZGlza0FjYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rzc19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRoLTRjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZGVjX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vbGRfcmVvdXJjZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19Sb3lhbHR5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfd2VsaW5rYnJpZGdlX2VuZHBvaW50X2J1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLXJvY2tldG1xNS1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1rYWZrYTMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX3Ztd2FyZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2lkbWVfbWJtX2ZvdW5kYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYzZhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9jYWxsbm90aWZ5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtM2QiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2tvb21hcCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19lc3NkMiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1hbXFwLWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3Bvb2xfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRod2VzdC0yYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3Y3BoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfaGVjc194IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGVzX2JhY2t1cCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lcHMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmVfYWxsIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX3JvdW5kdGFibGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXh0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcGZzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1tb3Njb3ctMWIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FwcHN0YWdlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fYXBwbGljYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfY29sZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Jkc19jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19ncHVfZzVyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfbWVzc2FnZW92ZXI1ZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19yaSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbm9ydGh3ZXN0LTJjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWVmX3BsYXRpbnVtIiwiaWQiOiIwIn1dLCJwcm9qZWN0Ijp7ImRvbWFpbiI6eyJuYW1lIjoiemhyMTY4LSIsImlkIjoiZWE2NmI4MjUyNDQxNGZhZWE0ODlhMWNkMGE4OWQ2OTAifSwibmFtZSI6ImNuLW5vcnRoLTQiLCJpZCI6ImQyNDM0OGFkZDVjYjQ1YTBhNjNlZWU1NjM2NDU0NWEwIn0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDI6MjU6MjUuMDQzMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBPsHXrn6Z+ka24gxIgQgfx2V85C0+CELCnuKGwrCDxGhiTLQiKDD8plG8HmLkTzxCmajyHvs5YxlQAru7nLW2kFe2ZaGgEgDkNeaT1xr6-kw7PEf3jnFAEat2soPINmnbdCloS1n2fgUcd4HhSRYDyKd+5PsvFKuW0tiIYAQ3vcKVpRsxE5iUWsl1j-x3hNKsr+ReZ4xCT1sOas4JZ-V9nqj9f28+QK611jksKp9C3yYXn4kFTl58R745qP4Orekv4AkwclbT37gZ9a2EtlhUtJr5dVuD14KG+TUK02kW2yKonJiWZ-0sa-qshmWjzz55fvz+dId0XeBiW+PlsNTJX", // 请替换为有效Token
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          const parsedData = JSON.parse(response.result.toString()) as agriculture;
          this.agriculturemodule = parsedData;
          console.info('agriculturemodule:' + JSON.stringify(this.agriculturemodule));
          thresholdAgriculture = this.agriculturemodule.Threshold;
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
        }
      }
    });
  }

  getTemperatureHumidityFromShadow() {
    let HttpRequest = http.createHttp();
    let url = 'https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/684a292a32771f177b4137cf_agriculture/shadow';
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "X-Auth-Token": "MIIN0AYJKoZIhvcNAQcCoIINwTCCDb0CAQExDTALBglghkgBZQMEAgEwggviBgkqhkiG9w0BBwGgggvTBIILz3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDI6MjU6MjUuMDQzMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiY2F0YWxvZyI6W10sInJvbGVzIjpbeyJuYW1lIjoidGVfYWRtaW4iLCJpZCI6IjAifSx7Im5hbWUiOiJ0ZV9hZ2VuY3kiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3JlcF9hY2NlbGVyYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZGlza0FjYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rzc19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRoLTRjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZGVjX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vbGRfcmVvdXJjZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19Sb3lhbHR5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfd2VsaW5rYnJpZGdlX2VuZHBvaW50X2J1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLXJvY2tldG1xNS1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1rYWZrYTMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX3Ztd2FyZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2lkbWVfbWJtX2ZvdW5kYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYzZhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9jYWxsbm90aWZ5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtM2QiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2tvb21hcCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19lc3NkMiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1hbXFwLWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3Bvb2xfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRod2VzdC0yYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3Y3BoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfaGVjc194IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGVzX2JhY2t1cCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lcHMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmVfYWxsIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX3JvdW5kdGFibGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXh0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcGZzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1tb3Njb3ctMWIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FwcHN0YWdlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fYXBwbGljYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfY29sZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Jkc19jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19ncHVfZzVyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfbWVzc2FnZW92ZXI1ZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19yaSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbm9ydGh3ZXN0LTJjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWVmX3BsYXRpbnVtIiwiaWQiOiIwIn1dLCJwcm9qZWN0Ijp7ImRvbWFpbiI6eyJuYW1lIjoiemhyMTY4LSIsImlkIjoiZWE2NmI4MjUyNDQxNGZhZWE0ODlhMWNkMGE4OWQ2OTAifSwibmFtZSI6ImNuLW5vcnRoLTQiLCJpZCI6ImQyNDM0OGFkZDVjYjQ1YTBhNjNlZWU1NjM2NDU0NWEwIn0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDI6MjU6MjUuMDQzMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBPsHXrn6Z+ka24gxIgQgfx2V85C0+CELCnuKGwrCDxGhiTLQiKDD8plG8HmLkTzxCmajyHvs5YxlQAru7nLW2kFe2ZaGgEgDkNeaT1xr6-kw7PEf3jnFAEat2soPINmnbdCloS1n2fgUcd4HhSRYDyKd+5PsvFKuW0tiIYAQ3vcKVpRsxE5iUWsl1j-x3hNKsr+ReZ4xCT1sOas4JZ-V9nqj9f28+QK611jksKp9C3yYXn4kFTl58R745qP4Orekv4AkwclbT37gZ9a2EtlhUtJr5dVuD14KG+TUK02kW2yKonJiWZ-0sa-qshmWjzz55fvz+dId0XeBiW+PlsNTJX", // 请替换为有效Token
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        const resultStr = resultToString(response.result);
        try {
          const data = JSON.parse(resultStr) as ShadowResponse;
          if (
            data.shadow &&
              data.shadow.length > 0 &&
            data.shadow[0].reported &&
            data.shadow[0].reported.properties
          ) {
            this.temperature = data.shadow[0].reported.properties.Temperature ?? 0;
            this.humidity = data.shadow[0].reported.properties.Humidity ?? 0;
            console.info('成功获取温湿度数据 - 温度:', this.temperature, '湿度:', this.humidity);
          } else {
            console.info('设备影子数据中没有找到温湿度数据');
          }
        } catch (error) {
          console.error('解析华为云返回数据时出错:', error);
        }
      } else {
        console.error('华为云设备影子接口请求失败，状态码:', response.responseCode);
      }
    }).catch((error: Error) => {
      console.error('华为云设备影子接口请求异常:', error);
    });
  }

  getPm25FromShadow() {
    let HttpRequest = http.createHttp();
    let url = 'https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676e1ad52ff1872637cb34b5_PM2_5_Monitoring/shadow';
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "X-Auth-Token": "MIIN0AYJKoZIhvcNAQcCoIINwTCCDb0CAQExDTALBglghkgBZQMEAgEwggviBgkqhkiG9w0BBwGgggvTBIILz3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDI6MjU6MjUuMDQzMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiY2F0YWxvZyI6W10sInJvbGVzIjpbeyJuYW1lIjoidGVfYWRtaW4iLCJpZCI6IjAifSx7Im5hbWUiOiJ0ZV9hZ2VuY3kiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3JlcF9hY2NlbGVyYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZGlza0FjYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rzc19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRoLTRjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZGVjX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vbGRfcmVvdXJjZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19Sb3lhbHR5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfd2VsaW5rYnJpZGdlX2VuZHBvaW50X2J1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLXJvY2tldG1xNS1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1rYWZrYTMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX3Ztd2FyZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2lkbWVfbWJtX2ZvdW5kYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYzZhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9jYWxsbm90aWZ5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtM2QiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2tvb21hcCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19lc3NkMiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1hbXFwLWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3Bvb2xfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRod2VzdC0yYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3Y3BoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfaGVjc194IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGVzX2JhY2t1cCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lcHMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmVfYWxsIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX3JvdW5kdGFibGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXh0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcGZzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1tb3Njb3ctMWIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FwcHN0YWdlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fYXBwbGljYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfY29sZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Jkc19jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19ncHVfZzVyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfbWVzc2FnZW92ZXI1ZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19yaSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbm9ydGh3ZXN0LTJjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWVmX3BsYXRpbnVtIiwiaWQiOiIwIn1dLCJwcm9qZWN0Ijp7ImRvbWFpbiI6eyJuYW1lIjoiemhyMTY4LSIsImlkIjoiZWE2NmI4MjUyNDQxNGZhZWE0ODlhMWNkMGE4OWQ2OTAifSwibmFtZSI6ImNuLW5vcnRoLTQiLCJpZCI6ImQyNDM0OGFkZDVjYjQ1YTBhNjNlZWU1NjM2NDU0NWEwIn0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDI6MjU6MjUuMDQzMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBPsHXrn6Z+ka24gxIgQgfx2V85C0+CELCnuKGwrCDxGhiTLQiKDD8plG8HmLkTzxCmajyHvs5YxlQAru7nLW2kFe2ZaGgEgDkNeaT1xr6-kw7PEf3jnFAEat2soPINmnbdCloS1n2fgUcd4HhSRYDyKd+5PsvFKuW0tiIYAQ3vcKVpRsxE5iUWsl1j-x3hNKsr+ReZ4xCT1sOas4JZ-V9nqj9f28+QK611jksKp9C3yYXn4kFTl58R745qP4Orekv4AkwclbT37gZ9a2EtlhUtJr5dVuD14KG+TUK02kW2yKonJiWZ-0sa-qshmWjzz55fvz+dId0XeBiW+PlsNTJX", // 请替换为有效Token
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        const resultStr = resultToString(response.result);
        try {
          const data = JSON.parse(resultStr) as ShadowResponse;
          if (
            data.shadow &&
              data.shadow.length > 0 &&
            data.shadow[0].reported &&
            data.shadow[0].reported.properties
          ) {
            const props = data.shadow[0].reported.properties;
            if (typeof props.pm2_5_data === 'number') {
              this.pmmodule.PM25Data = props.pm2_5_data;
              console.info('成功获取PM2.5数据:', this.pmmodule.PM25Data);
            } else if (typeof props.PM2_5 === 'number') {
              this.pmmodule.PM25Data = props.PM2_5;
              console.info('成功获取PM2.5数据(PM2_5):', this.pmmodule.PM25Data);
            } else {
              console.info('设备影子数据中没有找到PM2.5数据');
            }
          }
        } catch (error) {
          console.error('解析华为云返回数据时出错:', error);
        }
      } else {
        console.error('华为云设备影子接口请求失败，状态码:', response.responseCode);
      }
    }).catch((error: Error) => {
      console.error('华为云设备影子接口请求异常:', error);
    });
  }

  getNoiseFromShadow() {
    let HttpRequest = http.createHttp();
    let url = 'https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676f5798ef99673c8ada2618_NoiseDetection/shadow';
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "X-Auth-Token": "MIIN0AYJKoZIhvcNAQcCoIINwTCCDb0CAQExDTALBglghkgBZQMEAgEwggviBgkqhkiG9w0BBwGgggvTBIILz3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDI6MjU6MjUuMDQzMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiY2F0YWxvZyI6W10sInJvbGVzIjpbeyJuYW1lIjoidGVfYWRtaW4iLCJpZCI6IjAifSx7Im5hbWUiOiJ0ZV9hZ2VuY3kiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3JlcF9hY2NlbGVyYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZGlza0FjYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rzc19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRoLTRjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZGVjX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vbGRfcmVvdXJjZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19Sb3lhbHR5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfd2VsaW5rYnJpZGdlX2VuZHBvaW50X2J1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLXJvY2tldG1xNS1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1rYWZrYTMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX3Ztd2FyZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2lkbWVfbWJtX2ZvdW5kYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYzZhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9jYWxsbm90aWZ5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtM2QiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2tvb21hcCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19lc3NkMiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1hbXFwLWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3Bvb2xfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRod2VzdC0yYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3Y3BoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfaGVjc194IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGVzX2JhY2t1cCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lcHMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmVfYWxsIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX3JvdW5kdGFibGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXh0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcGZzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1tb3Njb3ctMWIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FwcHN0YWdlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fYXBwbGljYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfY29sZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Jkc19jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19ncHVfZzVyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfbWVzc2FnZW92ZXI1ZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19yaSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbm9ydGh3ZXN0LTJjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWVmX3BsYXRpbnVtIiwiaWQiOiIwIn1dLCJwcm9qZWN0Ijp7ImRvbWFpbiI6eyJuYW1lIjoiemhyMTY4LSIsImlkIjoiZWE2NmI4MjUyNDQxNGZhZWE0ODlhMWNkMGE4OWQ2OTAifSwibmFtZSI6ImNuLW5vcnRoLTQiLCJpZCI6ImQyNDM0OGFkZDVjYjQ1YTBhNjNlZWU1NjM2NDU0NWEwIn0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDI6MjU6MjUuMDQzMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBPsHXrn6Z+ka24gxIgQgfx2V85C0+CELCnuKGwrCDxGhiTLQiKDD8plG8HmLkTzxCmajyHvs5YxlQAru7nLW2kFe2ZaGgEgDkNeaT1xr6-kw7PEf3jnFAEat2soPINmnbdCloS1n2fgUcd4HhSRYDyKd+5PsvFKuW0tiIYAQ3vcKVpRsxE5iUWsl1j-x3hNKsr+ReZ4xCT1sOas4JZ-V9nqj9f28+QK611jksKp9C3yYXn4kFTl58R745qP4Orekv4AkwclbT37gZ9a2EtlhUtJr5dVuD14KG+TUK02kW2yKonJiWZ-0sa-qshmWjzz55fvz+dId0XeBiW+PlsNTJX", // 请替换为有效Token
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        const resultStr = resultToString(response.result);
        try {
          const data = JSON.parse(resultStr) as ShadowResponse;
          const props = data.shadow?.[0]?.reported?.properties;
          if (props && typeof props.NoiseVolume === 'number') {
            this.noisemodule.NoiseVolume = Number(props.NoiseVolume.toFixed(2));
            this.noisemodule.Threshold = props.Threshold ?? 0;
            console.info('成功获取噪音数据:', this.noisemodule.NoiseVolume);
          } else {
            console.info('设备影子数据中没有找到噪音数据');
          }
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
        }
      }
    });
  }

  getData(){
    this.getNoiseData()
    this.getPmData()
    this.getagricultureData()
    this.getTemperatureHumidityFromShadow()
    this.getPm25FromShadow()
    this.getNoiseFromShadow()
  }

  aboutToAppear() {
    this.getData();
  }
}


class noiseModule{
  NoiseVolume: number = 0
  Threshold: number = 0
}

class pmModule{
  PM25Data: number = 0
  Threshold: number = 0
}

class agriculture{
  agricultureData:number=0
  Threshold: number = 0
}

class debugLog{
  success: boolean = false
}

function resultToString(result: string | Object | ArrayBuffer): string {
  if (typeof result === 'string') {
    return result
  }
  if (result instanceof ArrayBuffer) {
    let uint8Arr = new Uint8Array(result)
    let str = ''
    for (let i = 0; i < uint8Arr.length; i++) {
      str += String.fromCharCode(uint8Arr[i])
    }
    return str
  }
  if (typeof result === 'object') {
    return JSON.stringify(result)
  }
  return ''
}





