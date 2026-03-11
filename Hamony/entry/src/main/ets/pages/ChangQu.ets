import { McLineChart, Options } from '@mcui/mccharts'
import { router } from '@kit.ArkUI'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'

let thresholdPM: number = 0
let thresholdNoise: number = 0
let thresholdAgriculture: number = 0

interface ShadowProperties {
  FanStatus?: number
  LEDStatus?: number
  Temperature?: number
  Humidity?: number
  Lux?: number
  Temperature_Threshold?: number
  Humidity_Threshold?: number
  Lux_Threshold?: number
  Gear?: number
  PM2_5?: number
  pm2_5_data?: number // 新增，兼容华为云返回字段
  NoiseStatus?: number // 新增，兼容噪音
  NoiseVolume?: number // 新增，兼容噪音
  Threshold?: number // 新增，兼容噪音阈值
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

@Entry
@Component
struct Index {
  @State noisemodule: noiseModule = new noiseModule()
  @State pmmodule: pmModule = new pmModule()
  @State agriculturemodule: agriculture = new agriculture()
  @State debuglog: debugLog = new debugLog()
  @State temperature: number = 0
  @State humidity: number = 0
  // 第一个图表的数据（可以与第一个相同或不同）
  @State seriesOption1: Options = new Options({
    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
      name: '数值'
    },
    series: [
      {
        name: '平均温度',
        data: [13, 21, 15, 16, 27, 30, 18]
      },
      {
        name: '平均湿度',
        data: [60, 40, 55, 65, 55, 45, 70]
      },
      {
        name: '平均噪音dB',
        data: [26, 23, 42, 63, 45, 32, 25]
      },
      {
        name: '平均温度℃',
        data: [28, 30, 30, 15, 20, 15, 23]
      }
    ]
  })

  // 动态修改数据
  aboutToAppear() {
    this.getTemperatureHumidityFromShadow()
    setTimeout(() => {
      // 更新第一个图表的数据
      this.seriesOption1.setVal({
        series: [
          {
            name: '平均PM2.5',
            data: [11, 11, 15, 13, 12, 19, 10]
          },
          {
            name: '平均湿度%',
            data: [38, 20, 30, 25, 40, 35, 45]
          },
          {
            name: '平均噪音dB',
            data: [26, 23, 42, 63, 45, 32, 25]
          },
          {
            name: '平均温度℃',
            data: [28, 30, 30, 15, 20, 15, 23]
          }
        ]
      })


    }, 2000)
    this.getData()
  }

  // 第二个图表的数据（可以与第一个相同或不同）
  @State seriesOption2: Options = new Options({
    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
      name: '数值'
    },
    series: [
      {
        name: '平均PM2.5',
        data: [15, 11, 25, 13, 27, 30, 28]
      },
      {
        name: '平均湿度',
        data: [30, 40, 55, 35, 65, 45, 40]
      },
      {
        name: '平均噪音dB',
        data: [56, 43, 52, 63, 48, 32, 35]
      },
      {
        name: '平均温度℃',
        data: [28, 30, 30, 15, 20, 15, 23]
      }
    ]
  })

  // 动态修改数据
  aboutToAppear2() {
    setTimeout(() => {
      // 更新第二个图表的数据
      this.seriesOption1.setVal({
        series: [
          {
            name: '平均PM2.5',
            data: [15, 11, 25, 13, 27, 30, 28]
          },
          {
            name: '平均湿度',
            data: [30, 40, 55, 35, 65, 45, 40]
          },
          {
            name: '平均噪音dB',
            data: [56, 43, 52, 63, 48, 32, 35]
          },
          {
            name: '平均温度℃',
            data: [28, 30, 30, 15, 20, 15, 23]
          }
        ]
      })


    }, 2000)
  }
  // 第三个图表的数据（可以与第一个相同或不同）
  @State seriesOption3: Options = new Options({
    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
      name: '数值'
    },
    series: [
      {
        name: '平均PM2.5',
        data: [15, 11, 25, 13, 27, 30, 28]
      },
      {
        name: '平均湿度',
        data: [30, 40, 55, 35, 65, 45, 40]
      },
      {
        name: '平均噪音dB',
        data: [56, 43, 52, 63, 48, 32, 35]
      },
      {
        name: '平均温度℃',
        data: [28, 30, 30, 15, 20, 15, 23]
      }
    ]
  })

  // 动态修改数据
  aboutToAppear3() {
    setTimeout(() => {
      // 更新第三个图表的数据
      this.seriesOption1.setVal({
        series: [
          {
            name: '平均PM2.5',
            data: [10, 11, 15, 23, 17, 20, 28]
          },
          {
            name: '平均湿度',
            data: [34, 30, 45, 37, 25, 45, 30]
          },
          {
            name: '平均噪音dB',
            data: [66, 45, 52, 33, 78, 42, 35]
          },
          {
            name: '平均温度℃',
            data: [28, 30, 30, 15, 20, 15, 23]
          }
        ]
      })


    }, 2000)
  }


  build() {
    Tabs({barPosition:BarPosition.Start}){
      TabContent(){
        Column({space:40}) { // 使用Column布局使两个图表垂直排列
          /*Text('厂区一')
            .fontSize(20)
            .fontWeight(700)
            .margin(10)*/
          Column({space:15}){
            Row(){

              Image($r('app.media.fanhui2'))
                .width(20)
                .height(20)
                .onClick(()=>{
                  router.back()
                })
              Text('实时数据')
                .fontSize(20)
                .fontWeight(500)
                .fontColor('#ff4e81e7')

              Blank()
              Image($r('app.media.refresh'))
                .width(25)
                .onClick(() => {
                  this.getData()
                })
            }
            .width('90%')
            /*Row(){
              Text('空气湿度：16%')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)*/
            Row(){
              Text('PM2.5：'+this.pmmodule.PM25Data+' 微克')
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            Row(){
              Text('噪音：' + this.noisemodule.NoiseVolume)
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            Row(){
              Text('温度：' + this.temperature)
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            Row(){
              Text('湿度：' + this.humidity)
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
          }
          .backgroundColor('#ffc1ceee')
          .borderRadius(20)
          .width('90%')
          .height(220)
          .justifyContent(FlexAlign.SpaceAround)
          Column(){
            Row() {
              McLineChart({
                options: this.seriesOption1
              })
            }
            .height('50%')
            Text('历史数据')
              .fontSize(20)
              .fontWeight(500)
              .fontColor('#ff4e81e7')

          }
        }
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.img'))
        .backgroundImageSize({width:'100%',height:'100%'})
      }
      .tabBar('厂区一')

      TabContent(){
        Column({space:40}) { // 使用Column布局使两个图表垂直排列
          /*Text('厂区二')
            .fontSize(20)
            .fontWeight(700)
            .margin(10)*/
          Column({space:15}){
            Row(){
              Image($r('app.media.fanhui2'))
                .width(20)
                .height(20)
                .onClick(()=>{
                  router.back()
                })
              Text('实时数据')
                .fontSize(20)
                .fontWeight(500)
                .fontColor('#ff4e81e7')
            }
            .width('90%')
            .margin({top:10})
            Row(){
              Text('PM2.5：'+this.pmmodule.PM25Data+' 微克')
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            Row(){
              Text('空气湿度：30')
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)

            Row(){
              Text('噪音：' + this.noisemodule.NoiseVolume)
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            Row(){
              Text('温度：23')
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
          }
          .backgroundColor('#ffc1ceee')
          .borderRadius(20)
          .width('90%')
          .height(220)
          .justifyContent(FlexAlign.SpaceAround)
          Column(){
            Row() {
              McLineChart({
                options: this.seriesOption1
              })
            }
            .height('50%')
            Text('历史数据')
              .fontSize(20)
              .fontWeight(500)
              .fontColor('#ff4e81e7')
            Image($r('app.media.fanhui2'))
              .width(30)
              .height(30)
              .margin({top:20,left:-300})
              .onClick(()=>{
                router.back()
              })
          }

        }
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.img'))
        .backgroundImageSize({width:'100%',height:'100%'})
      }
      .tabBar('厂区二')

      TabContent(){
        Column({space:40}) { // 使用Column布局使两个图表垂直排列
          /* Text('厂区三')
             .fontSize(20)
             .fontWeight(700)
             .margin(10)*/
          Column({space:15}){
            Row(){
              Image($r('app.media.fanhui2'))
                .width(20)
                .height(20)
                .onClick(()=>{
                  router.back()
                })
              Text('实时数据')
                .fontSize(20)
                .fontWeight(500)
                .fontColor('#ff4e81e7')
            }
            .width('90%')
            .margin({top:10})
            Row(){
              Text('PM2.5：'+this.pmmodule.PM25Data+' 微克')
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            Row(){
              Text('空气湿度：20')
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)

            Row(){
              Text('噪音：' + this.noisemodule.NoiseVolume)
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            Row(){
              Text('温度：20')
                .fontSize(20)
              Text('良好')
                .fontSize(20)
            }
            .width('100%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
          }
          .backgroundColor('#ffc1ceee')
          .borderRadius(20)
          .width('90%')
          .height(220)
          .justifyContent(FlexAlign.SpaceAround)
          Column(){
            Row() {
              McLineChart({
                options: this.seriesOption1
              })
            }
            .height('50%')
            Text('历史数据')
              .fontSize(20)
              .fontWeight(500)
              .fontColor('#ff4e81e7')
          }
        }
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.img'))
        .backgroundImageSize({width:'100%',height:'100%'})
      }
      .tabBar('厂区三')

    }
    .backgroundImage($r('app.media.img'))
    .backgroundImageSize({width:'100%',height:'100%'})

  }

  getNoiseData() {
    let HttpRequest = http.createHttp()
    let url = 'https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/676f5798ef99673c8ada2618_NoiseDetection/shadow'
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "X-Auth-Token": "MIINmgYJKoZIhvcNAQcCoIINizCCDYcCAQExDTALBglghkgBZQMEAgEwggusBgkqhkiG9w0BBwGgggudBIILmXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDg6MTg6NDkuMjcyMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZXNfYmFja3VwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDg6MTg6NDkuMjcyMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAScr9ZR3jrpKIGg1-qoKREMKomJ5tcLNVxE7Sm7JwlWrZH+43SOmWcO1q2KZ5iV8ZrEDV9XPa8fgotuY+rOVCEUAgMdKQUay0YdTbUCxtyks-bpXHouaVRzcN9ckUx7iHdP1LEaREuFiHrcvSnyM9TExvQsi0OGADpMtJiMFtZpz5eId5x3BRI3WKW1qbLzBAnXrDkOgmSb+bYCBymcwszwkSP1g+z3nF22VUis8LsAXpYdhQ+aH8kW4A-w09w3L+Bvoo9sCOIZfw7rie7GsbgN1OM0HCs53wotFXy69sfMUmDp0IiOE1vBaifOfSA6KrEET4A2CE0ASFp+9jii8oQ",
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
        "X-Auth-Token": "MIINmgYJKoZIhvcNAQcCoIINizCCDYcCAQExDTALBglghkgBZQMEAgEwggusBgkqhkiG9w0BBwGgggudBIILmXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDg6MTg6NDkuMjcyMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZXNfYmFja3VwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDg6MTg6NDkuMjcyMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAScr9ZR3jrpKIGg1-qoKREMKomJ5tcLNVxE7Sm7JwlWrZH+43SOmWcO1q2KZ5iV8ZrEDV9XPa8fgotuY+rOVCEUAgMdKQUay0YdTbUCxtyks-bpXHouaVRzcN9ckUx7iHdP1LEaREuFiHrcvSnyM9TExvQsi0OGADpMtJiMFtZpz5eId5x3BRI3WKW1qbLzBAnXrDkOgmSb+bYCBymcwszwkSP1g+z3nF22VUis8LsAXpYdhQ+aH8kW4A-w09w3L+Bvoo9sCOIZfw7rie7GsbgN1OM0HCs53wotFXy69sfMUmDp0IiOE1vBaifOfSA6KrEET4A2CE0ASFp+9jii8oQ",
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          console.info('getData success:' + response.result);
          // 使用类型断言（这里假设响应体的结构是正确的）
          const parsedData = JSON.parse(response.result.toString()) as pmModule;
          this.pmmodule = parsedData;
          console.info('pmmodule:' + JSON.stringify(this.pmmodule));
          thresholdPM = this.pmmodule.Threshold;
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
          // 可以设置一个错误状态或显示错误信息
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
        "X-Auth-Token": "MIINmgYJKoZIhvcNAQcCoIINizCCDYcCAQExDTALBglghkgBZQMEAgEwggusBgkqhkiG9w0BBwGgggudBIILmXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDg6MTg6NDkuMjcyMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZXNfYmFja3VwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDg6MTg6NDkuMjcyMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAScr9ZR3jrpKIGg1-qoKREMKomJ5tcLNVxE7Sm7JwlWrZH+43SOmWcO1q2KZ5iV8ZrEDV9XPa8fgotuY+rOVCEUAgMdKQUay0YdTbUCxtyks-bpXHouaVRzcN9ckUx7iHdP1LEaREuFiHrcvSnyM9TExvQsi0OGADpMtJiMFtZpz5eId5x3BRI3WKW1qbLzBAnXrDkOgmSb+bYCBymcwszwkSP1g+z3nF22VUis8LsAXpYdhQ+aH8kW4A-w09w3L+Bvoo9sCOIZfw7rie7GsbgN1OM0HCs53wotFXy69sfMUmDp0IiOE1vBaifOfSA6KrEET4A2CE0ASFp+9jii8oQ",
        "Content-Type": "application/json"
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          console.info('getData success:' + response.result);
          // 使用类型断言（这里假设响应体的结构是正确的）
          const parsedData = JSON.parse(response.result.toString()) as agriculture;
          this.agriculturemodule = parsedData;
          console.info('agriculturemodule:' + JSON.stringify(this.agriculturemodule));
          thresholdAgriculture = this.agriculturemodule.Threshold;
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
          // 可以设置一个错误状态或显示错误信息
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
        "X-Auth-Token": "MIINmgYJKoZIhvcNAQcCoIINizCCDYcCAQExDTALBglghkgBZQMEAgEwggusBgkqhkiG9w0BBwGgggudBIILmXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDg6MTg6NDkuMjcyMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZXNfYmFja3VwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDg6MTg6NDkuMjcyMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAScr9ZR3jrpKIGg1-qoKREMKomJ5tcLNVxE7Sm7JwlWrZH+43SOmWcO1q2KZ5iV8ZrEDV9XPa8fgotuY+rOVCEUAgMdKQUay0YdTbUCxtyks-bpXHouaVRzcN9ckUx7iHdP1LEaREuFiHrcvSnyM9TExvQsi0OGADpMtJiMFtZpz5eId5x3BRI3WKW1qbLzBAnXrDkOgmSb+bYCBymcwszwkSP1g+z3nF22VUis8LsAXpYdhQ+aH8kW4A-w09w3L+Bvoo9sCOIZfw7rie7GsbgN1OM0HCs53wotFXy69sfMUmDp0IiOE1vBaifOfSA6KrEET4A2CE0ASFp+9jii8oQ", // 请替换为有效Token
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
        "X-Auth-Token": "MIINmgYJKoZIhvcNAQcCoIINizCCDYcCAQExDTALBglghkgBZQMEAgEwggusBgkqhkiG9w0BBwGgggudBIILmXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDg6MTg6NDkuMjcyMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZXNfYmFja3VwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDg6MTg6NDkuMjcyMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAScr9ZR3jrpKIGg1-qoKREMKomJ5tcLNVxE7Sm7JwlWrZH+43SOmWcO1q2KZ5iV8ZrEDV9XPa8fgotuY+rOVCEUAgMdKQUay0YdTbUCxtyks-bpXHouaVRzcN9ckUx7iHdP1LEaREuFiHrcvSnyM9TExvQsi0OGADpMtJiMFtZpz5eId5x3BRI3WKW1qbLzBAnXrDkOgmSb+bYCBymcwszwkSP1g+z3nF22VUis8LsAXpYdhQ+aH8kW4A-w09w3L+Bvoo9sCOIZfw7rie7GsbgN1OM0HCs53wotFXy69sfMUmDp0IiOE1vBaifOfSA6KrEET4A2CE0ASFp+9jii8oQ", // 请替换为有效Token
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
        "X-Auth-Token": "MIINmgYJKoZIhvcNAQcCoIINizCCDYcCAQExDTALBglghkgBZQMEAgEwggusBgkqhkiG9w0BBwGgggudBIILmXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDg6MTg6NDkuMjcyMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZXNfYmFja3VwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDg6MTg6NDkuMjcyMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAScr9ZR3jrpKIGg1-qoKREMKomJ5tcLNVxE7Sm7JwlWrZH+43SOmWcO1q2KZ5iV8ZrEDV9XPa8fgotuY+rOVCEUAgMdKQUay0YdTbUCxtyks-bpXHouaVRzcN9ckUx7iHdP1LEaREuFiHrcvSnyM9TExvQsi0OGADpMtJiMFtZpz5eId5x3BRI3WKW1qbLzBAnXrDkOgmSb+bYCBymcwszwkSP1g+z3nF22VUis8LsAXpYdhQ+aH8kW4A-w09w3L+Bvoo9sCOIZfw7rie7GsbgN1OM0HCs53wotFXy69sfMUmDp0IiOE1vBaifOfSA6KrEET4A2CE0ASFp+9jii8oQ", // 请替换为有效Token
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
    this.getNoiseFromShadow() // 新增调用
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