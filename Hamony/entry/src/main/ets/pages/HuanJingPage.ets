import router from '@ohos.router'
import http from '@ohos.net.http';
import {PM2_5Module} from '../datacenter/PM2_5Module'
import {NoiseModule} from './yingjian/NoiseModule'

const token: string = "MIIN4QYJKoZIhvcNAQcCoIIN0jCCDc4CAQExDTALBglghkgBZQMEAgEwggvzBgkqhkiG9w0BBwGgggvkBIIL4HsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDMtMThUMDE6MjA6NDYuMTczMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wYW5ndSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3dlbGlua2JyaWRnZV9lbmRwb2ludF9idXkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1yb2NrZXRtcTUtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMta2Fma2EzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlY19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3VuaWJ1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl92bXdhcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZG1lX21ibV9mb3VuZGF0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2M2YSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX211bHRpX2JpbmQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fY2FsbG5vdGlmeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTNkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19wcm9ncmVzc2JhciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nlc19yZXNvdXJjZWdyb3VwX3RhZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vZmZsaW5lX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19yZXR5cGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9rb29tYXAiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXNzZDIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtYW1xcC1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19wb29sX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1zb3V0aHdlc3QtMmIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2NwaCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vZmZsaW5lX2Rpc2tfNCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3ZGV2IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX3dlbGlua3JlZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h2X3ZlbmRvciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2hlY3NfeCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlc19iYWNrdXAiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXBzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlX2FsbCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9yb3VuZHRhYmxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2V4dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Bmc19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbW9zY293LTFiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hcHBzdGFnZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2FwcGxpY2F0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2NvbGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9yZHNfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZ3B1X2c1ciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX21lc3NhZ2VvdmVyNWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfcmkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW5vcnRod2VzdC0yYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2llZl9wbGF0aW51bSIsImlkIjoiMCJ9XSwiaXNzdWVkX2F0IjoiMjAyNS0wMy0xN1QwMToyMDo0Ni4xNzMwMDBaIiwidXNlciI6eyJkb21haW4iOnsibmFtZSI6InpocjE2OC0iLCJpZCI6ImVhNjZiODI1MjQ0MTRmYWVhNDg5YTFjZDBhODlkNjkwIn0sIm5hbWUiOiJ5d2IiLCJwYXNzd29yZF9leHBpcmVzX2F0IjoiIiwiaWQiOiI3ZDAzNzIxMGNjZmQ0OGM1YjY4OTgzMDZkYTcyNzIxNSJ9fX0xggHBMIIBvQIBATCBlzCBiTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwIU2hlblpoZW4xLjAsBgNVBAoMJUh1YXdlaSBTb2Z0d2FyZSBUZWNobm9sb2dpZXMgQ28uLCBMdGQxDjAMBgNVBAsMBUNsb3VkMRMwEQYDVQQDDApjYS5pYW0ucGtpAgkA3LMrXRBhahAwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGeXFZBx8EI8G5kioFVBmqMaox8uJzF-Q4kQdICh7VmsljVVsXSYiYf3TbqzA5KaUaM2-8yBHHdeU8fel6D85fziuhJoUBgB8ZDpNnniPKFvs2fInlS-ZBPKY4Gd1bFlLcJNgSlqvpHtrvve6zPGIAsujrfH+v053ABgQWzMAtBYOPHZCdYgR7mIPOk3bX0Bf8wQ5piIwA+5CBt9unXQdT-q5dFxZ9NP-1ns-BMEZFjksEHL8DzYbwwIEUmJ5RqarVc-I-YE00q65tsq9YFTik43oLjHrHBqclChG3CfyYG-wYD87KmxZPjHNVrKU+FCkQREirRAhRuS2BxBtMzYXSI="


@Entry
@Component
export default struct HuanJingPage {
  @State noisemodule:NoiseModule = new NoiseModule()
  @State Threshold: string = ''
  @State Threshold2: string = ''
  @State pm2_5module:PM2_5Module = new PM2_5Module()
  @State message: string = 'Hello World'
  aboutToAppear(): void {
    this.getHttpData()
    this.getHttpData3()
  }

  build() {
    Column(){
      //顶部
      Row(){
        Image($r('app.media.fanhui1'))
          .onClick(()=>{
            router.pushUrl({url:'pages/zhu'})
          })
          .width(30)
          .margin({left: 20,right:10})
        Text('环境监测')
          .fontSize(30)
      }
      .width('100%')
      .margin({top: 10})

      Tabs(){
        TabContent(){
          Column() {
            //设备运行状态
            Row() {
              Column() {
                Stack() {
                  Progress({ value: 15, total: 100, type: ProgressType.Ring })

                  Text('15')
                    .fontSize(20)
                }

                Text('正常')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 20 })
              }
              .width('50%')
              .height('100%')

              Column() {
                Stack() {
                  Progress({ value: 10, total: 100, type: ProgressType.Ring })

                  Text('10')
                    .fontSize(20)
                }

                Text('异常')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 20 })
              }
              .width('50%')
              .height('100%')
            }
            .width('100%')
            .height('20%')
            .margin({ top: 30 })

            //温度

            //相对湿度
            Column() {
              Row({space:20}){
                TextInput({placeholder:'请输入想要设定的阈值'})
                  .width(225)
                  .onChange((value) => {
                    this.Threshold = value
                  })
                Button('设置')
                  .onClick(() => {
                    this.getHttpData2()
                    setTimeout(() =>{
                      console.log("阈值："+this.Threshold)
                    },5000)
                  })
              }
              Column(){
                Button('查看PM2.5值')
                  .width(150).margin({top:20})
                  .onClick(()=>{
                    console.log("查看数据")
                    this.getHttpData()
                  })
              }
              Column() {
                Stack() {
                  Progress({ value: 60, total: 100, type: ProgressType.Eclipse })
                    .color('#17abe3')
                    .height(90)
                }
              }
              .position({x:23,y:120})
              .width(100)
              .height('100')
              Column() {

                Text("阈值为："+this.pm2_5module.shadow[0]?.reported?.properties?.Threshold)
                  .fontSize(23)
                Text("检测的PM2.5值为："+this.pm2_5module.shadow[0]?.reported?.properties?.pm2_5_data+"μg/m³")
                  .margin({top:10})
              }
              .position({x:110,y:140})
              .width('70%')
              .height('100%')
              Row({space:20}){
                TextInput({placeholder:'请输入想要设定的阈值'})
                  .width(225)
                  .onChange((value) => {
                    this.Threshold2 = value
                  })
                Button('设置')
                  .onClick(() => {
                    this.getHttpData4()
                    setTimeout(() =>{
                      console.log("阈值："+this.Threshold2)
                    },5000)
                  })

              }
              .width("90%")
              .position({x:30,y:240})
              Button('查看噪音值')
                .position({x:110,y:300})
                .borderRadius(8).backgroundColor(0x317aff)
                .width(150).margin(10)
                .onClick(()=>{
                  console.log("查看数据")
                  this.getHttpData3()
                })
              Column() {
                Stack() {
                  Progress({ value: 60, total: 100, type: ProgressType.Eclipse })
                    .color('#17abe3')
                    .height(90)
                }
              }
              .position({x:23,y:350})
              .width(100)
              .height('100')
              Text("阈值为："+this.noisemodule.shadow[0]?.reported?.properties?.Threshold)
                .position({x:180,y:380})
                .fontSize(23)
              Text("检测的噪音值为："+parseInt(this.noisemodule.shadow[0]?.reported?.properties?.NoiseVolume.toString())+'db')
                .position({x:135,y:420})
            }

            .width('100%')
            .height('140')
          }
          .width('100%')
          .height('100%')
        }
        .tabBar('厂区一')

        TabContent(){
          Column(){
            //设备运行状态
            Row(){
              Column(){
                Stack(){
                  Progress({value: 20,total: 100,type:ProgressType.Ring})

                  Text('20')
                    .fontSize(20)
                }
                Text('正常')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .margin({top: 20})
              }
              .width('50%')
              .height('100%')

              Column(){
                Stack(){
                  Progress({value: 15,total: 100,type:ProgressType.Ring})

                  Text('15')
                    .fontSize(20)
                }
                Text('异常')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .margin({top: 20})
              }
              .width('50%')
              .height('100%')
            }
            .width('100%')
            .height('20%')
            .margin({top: 30})

            //温度
            Row() {
              Column() {
                Stack() {
                  Progress({ value: 40, total: 100, type: ProgressType.Eclipse })
                    .color('#17abe3')
                    .height(80)
                }
              }
              .width('30%')
              .height('100%')
              .margin({top: 10,right: 20,left: 20})

              Column(){
                Row(){
                  Text('温度')
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .height('50%')

                Row(){
                  Text('25℃')
                    .fontSize(27)
                    .onClick(() => {
                      router.pushUrl({url: 'pages/ZheXianTuPage2'})
                    })

                  Text('(20～30℃)')
                    .fontSize(15)
                    .margin({left: 20})
                }
                .width('100%')
                .height('50%')
              }
              .width('70%')
              .height('100%')
            }
            .width('100%')
            .height('90')
            .margin({top: 20})

            Divider()
              .width('91%')
            //相对湿度
            Row() {
              Column(){
                Stack() {
                  Progress({ value: 60, total: 100, type: ProgressType.Eclipse })
                    .color('#17abe3')
                    .height(80)
                }
              }
              .width('30%')
              .height('100%')
              .margin({top: 10,right: 20,left: 20})

              Column(){
                Row(){
                  Text('湿度')
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .height('50%')

                Row(){
                  Text('38%')
                    .fontSize(27)
                    .onClick(() => {
                      router.pushUrl({url: 'pages/ZheXianTuPage2'})
                    })

                  Text('(30～40%)')
                    .fontSize(15)
                    .margin({left: 20})
                }
                .width('100%')
                .height('50%')
              }
              .width('70%')
              .height('100%')
            }
            .width('100%')
            .height('90')
            .margin({top:20})

            Divider()
              .width('91%')

          }
          .width('100%')
          .height('100%')
        }
        .tabBar('厂区二')
        TabContent(){
          Column(){
            //设备运行状态
            Row(){
              Column(){
                Stack(){
                  Progress({value: 25,total: 100,type:ProgressType.Ring})

                  Text('25')
                    .fontSize(20)
                }
                Text('正常')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .margin({top: 20})
              }
              .width('50%')
              .height('100%')

              Column(){
                Stack(){
                  Progress({value: 10,total: 100,type:ProgressType.Ring})

                  Text('10')
                    .fontSize(20)
                }
                Text('异常')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .margin({top: 20})
              }
              .width('50%')
              .height('100%')
            }
            .width('100%')
            .height('20%')
            .margin({top: 30})

            //温度
            Row() {
              Column() {
                Stack() {
                  Progress({ value: 40, total: 100, type: ProgressType.Eclipse })
                    .color('#17abe3')
                    .height(80)
                }
              }
              .width('30%')
              .height('100%')
              .margin({top: 10,right: 20,left: 20})

              Column(){
                Row(){
                  Text('温度')
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .height('45%')

                Row(){
                  Text('28℃')
                    .fontSize(30)
                    .onClick(() => {
                      router.pushUrl({url: 'pages/ZheXianTuPage3'})
                    })

                  Text('(20～30℃)')
                    .fontSize(15)
                    .margin({left: 20})
                }
                .width('100%')
                .height('50%')
              }
              .width('70%')
              .height('100%')
            }
            .width('100%')
            .height('140')
            .margin({top: 20})

            Divider()
              .width('91%')
            //相对湿度
            Row() {
              Column(){
                Stack() {
                  Progress({ value: 60, total: 100, type: ProgressType.Eclipse })
                    .color('#17abe3')
                    .height(80)
                }
              }
              .width('30%')
              .height('100%')
              .margin({top: 15,right: 20,left: 20})

              Column(){
                Row(){
                  Text('湿度')
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .height('50%')

                Row(){
                  Text('40%')
                    .fontSize(30)
                    .onClick(() => {
                      router.pushUrl({url: 'pages/ZheXianTuPage3'})
                    })

                  Text('(30～40%)')
                    .fontSize(15)
                    .margin({left: 20})
                }
                .width('100%')
                .height('50%')
              }
              .width('70%')
              .height('100%')
            }
            .width('100%')
            .height('100')

            Divider()
              .width('91%')

          }
          .width('100%')
          .height('100%')
        }
        .tabBar('厂区三')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'700'})
  }
  getHttpData() {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url: string = "https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676e1ad52ff1872637cb34b5_PM2_5_Monitoring/shadow"
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {

      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token
      },
      //      extraData: {
      //        "type": "guonei",
      //        "page": "1",
      //        "key": "562022ac0428bb47dacfca9f70260148"
      //      },
      connectTimeout: 60000, // 可选，默认为60s
      readTimeout: 60000, // 可选，默认为60s
    },
      (err, data) => {
        if (!err) {
          // data.result为http响应内容，可根据业务需要进行解析
          console.info('Result:' + data.result);
          console.info('code:' + data.responseCode);
          // data.header为http响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + data.cookies); // 8+
          //this.parseData(data.result)
          console.log(JSON.parse(data.result.toString()));
          this.pm2_5module = JSON.parse(data.result.toString())

          //
        } else {
          console.info('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁。
          httpRequest.destroy();
        }
      }

    )
  }
  getHttpData2() {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url: string = "https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676e1ad52ff1872637cb34b5_PM2_5_Monitoring/commands"
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {

      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': "application/json; charset=UTF-8",
        'X-Auth-Token': token
      },

      extraData: {
        "service_id": "PM2_5Detection",
        "command_name": "SetThreshold",
        "paras": {
          "Threshold": Number(this.Threshold)
        }
      },

      connectTimeout: 60000, // 可选，默认为60s
      readTimeout: 60000, // 可选，默认为60s
    },
      (err, data) => {
        if (!err) {
          // data.result为http响应内容，可根据业务需要进行解析
          console.info('Result:' + data.result);
          console.info('code:' + data.responseCode);
          // data.header为http响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + data.cookies); // 8+
          //this.parseData(data.result)

          console.log(JSON.parse(data.result.toString()));

          //
        } else {
          console.info('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁。
          httpRequest.destroy();
        }
      }

    )
  }
  getHttpData3() {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url: string = "https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676f5798ef99673c8ada2618_NoiseDetection/shadow"
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {

      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token
      },
      //      extraData: {
      //        "type": "guonei",
      //        "page": "1",
      //        "key": "562022ac0428bb47dacfca9f70260148"
      //      },
      connectTimeout: 60000, // 可选，默认为60s
      readTimeout: 60000, // 可选，默认为60s
    },
      (err, data) => {
        if (!err) {
          // data.result为http响应内容，可根据业务需要进行解析
          console.info('Result:' + data.result);
          console.info('code:' + data.responseCode);
          // data.header为http响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + data.cookies); // 8+
          //this.parseData(data.result)
          console.log(JSON.parse(data.result.toString()));
          this.noisemodule = JSON.parse(data.result.toString())

          //
        } else {
          console.info('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁。
          httpRequest.destroy();
        }
      }

    )
  }
  getHttpData4() {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url: string = "https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676f5798ef99673c8ada2618_NoiseDetection/commands"
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {

      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': "application/json; charset=UTF-8",
        'X-Auth-Token': token
      },

      extraData: {
        "service_id": "NoiseDetection",
        "command_name": "SetThreshold",
        "paras": { "Threshold": Number(this.Threshold2) }
      },

      connectTimeout: 60000, // 可选，默认为60s
      readTimeout: 60000, // 可选，默认为60s
    },
      (err, data) => {
        if (!err) {
          // data.result为http响应内容，可根据业务需要进行解析
          console.info('Result:' + data.result);
          console.info('code:' + data.responseCode);
          // data.header为http响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + data.cookies); // 8+
          //this.parseData(data.result)

          console.log(JSON.parse(data.result.toString()));

          //
        } else {
          console.info('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁。
          httpRequest.destroy();
        }
      }

    )
  }

}