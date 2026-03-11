import router from '@ohos.router'
import http from '@ohos.net.http';

const token: string = "MIINwAYJKoZIhvcNAQcCoIINsTCCDa0CAQExDTALBglghkgBZQMEAgEwggvSBgkqhkiG9w0BBwGgggvDBIILv3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMTRUMDI6MDU6MzAuMjMwMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9NYXBfYmV0YSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTNkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19wcm9ncmVzc2JhciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nlc19yZXNvdXJjZWdyb3VwX3RhZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vZmZsaW5lX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19yZXR5cGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9rb29tYXAiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXNzZDIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtYW1xcC1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19wb29sX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1zb3V0aHdlc3QtMmIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2NwaCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vZmZsaW5lX2Rpc2tfNCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3ZGV2IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX3dlbGlua3JlZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h2X3ZlbmRvciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2hlY3NfeCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlc19iYWNrdXAiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXBzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlX2FsbCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9yb3VuZHRhYmxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2V4dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Bmc19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbW9zY293LTFiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hcHBzdGFnZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2FwcGxpY2F0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2NvbGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9yZHNfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZ3B1X2c1ciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX21lc3NhZ2VvdmVyNWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfcmkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW5vcnRod2VzdC0yYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2llZl9wbGF0aW51bSIsImlkIjoiMCJ9XSwiaXNzdWVkX2F0IjoiMjAyNS0wNi0xM1QwMjowNTozMC4yMzAwMDBaIiwidXNlciI6eyJkb21haW4iOnsibmFtZSI6InpocjE2OC0iLCJpZCI6ImVhNjZiODI1MjQ0MTRmYWVhNDg5YTFjZDBhODlkNjkwIn0sIm5hbWUiOiJ5d2IiLCJwYXNzd29yZF9leHBpcmVzX2F0IjoiIiwiaWQiOiI3ZDAzNzIxMGNjZmQ0OGM1YjY4OTgzMDZkYTcyNzIxNSJ9fX0xggHBMIIBvQIBATCBlzCBiTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwIU2hlblpoZW4xLjAsBgNVBAoMJUh1YXdlaSBTb2Z0d2FyZSBUZWNobm9sb2dpZXMgQ28uLCBMdGQxDjAMBgNVBAsMBUNsb3VkMRMwEQYDVQQDDApjYS5pYW0ucGtpAgkA3LMrXRBhahAwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAACMSRC3JnwyCmWqJ8jGVVT4KA7RGiFPmV-EwHig6IMUqPCbVxqHfmtwfMqdW2Hr62XuG0vRXJkHFtWTaLQpmuXDlFmx0nXwW8dlRKqoUJ8NLyWlmncsT4JkMAl0z0wOvrpG2fsYhZVXj9ECvCQ-DxLo-5+OZPKtjMlaxUIwLDc697zvLmolFqhp6BUca6xamQ6Rzg9HExVsRitMgN0iwdZahLAd0C+J7YQHLCE4uyl+79ibBeEB7RDMzfQUgrMwiddi9ugpEFjf-kEeZIKl-uoqF5TfBhLoBaoat6CEddLh4sL7Cr-TbvOPsnyymNH3A5A7CDRdgtNwqlswrWQveYs="
@Entry
@Component
struct kongzhi {
  @State message: string = 'Hello World'
  build(){
    Column() {
      Row() {
        Row() {
          Image($r('app.media.u'))
            .width(35)
        }
        .onClick(()=>{
          router.back()
        })
        Row() {
          Text('厂区一')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 90 })
        }

        Row() {
          Image($r('app.media.n'))
            .width(40)
            .margin({ left: 85 })
            .backgroundColor('white')
            .borderRadius(15)
        }
        .onClick(() => {
          router.push({ url: 'pages/lianjie' })
        })
      }
      .width('100%')
      .height(50)
      //全部设备
      Row() {
        Text('全部设备')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('▼')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
      }
      .width('90%')
      .height(30)
      Row(){
        Text('全部 5')
          .fontSize(15)
          .fontColor('#8a8a8a')
      }
      .width('90%')
      .height(30)
      //设备
      Column(){
        Row(){
          Image($r('app.media.o'))
            .width(50)
            .margin({left:10})
          Text('蓝色LED灯')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Toggle({ type: ToggleType.Switch })
            .width(80)
            .height(25)
            .margin({left:90})
        }
        .width('90%')
        .height(90)
        .backgroundColor('white')
        .margin({top:20})
        .borderRadius(20)
        Row(){
          Image($r('app.media.p'))
            .width(50)
            .margin({left:10})
          Text('红色LED灯')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Toggle({ type: ToggleType.Switch,isOn:false })
            .width(80)
            .height(25)
            .margin({left:90})
            .onChange((isON)=>{
              if (isON) {
                this.getHttpData1()
              }else {
                this.getHttpData2()
              }
            })
        }
        .width('90%')
        .height(90)
        .backgroundColor('white')
        .margin({top:20})
        .borderRadius(20)
        Row(){
          Image($r('app.media.q'))
            .width(50)
            .margin({left:10})
          Text('绿色LED灯')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Toggle({ type: ToggleType.Switch ,isOn:true})
            .width(80)
            .height(25)
            .margin({left:90})

        }
        .width('90%')
        .height(90)
        .backgroundColor('white')
        .margin({top:20})
        .borderRadius(20)
        Row(){
          Image($r('app.media.r'))
            .width(50)
            .margin({left:10})
          Text('黄色LED灯')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Toggle({ type: ToggleType.Switch })
            .width(80)
            .height(25)
            .margin({left:90})
        }
        .width('90%')
        .height(90)
        .backgroundColor('white')
        .margin({top:20})
        .borderRadius(20)
        Row(){
          Image($r('app.media.s'))
            .width(50)
            .margin({left:10})
          Text('白色LED灯')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Toggle({ type: ToggleType.Switch })
            .width(80)
            .height(25)
            .margin({left:90})
        }
        .width('90%')
        .height(90)
        .backgroundColor('white')
        .margin({top:20})
        .borderRadius(20)
      }
      .width('100%')
      .height(570)

      Row(){
        Text('•')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#8a8a8a')
        Text('远程准备就绪')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#8a8a8a')
      }
      .width('95%')
      .margin({top:50})
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'700'})
  }
  request_url: string = "https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/671ef76965629b34009b20f9_Lamp01/commands"
  getHttpData1() {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url = this.request_url
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
        "service_id": "SmartLamp",
        "command_name": "SetLampStatus",
        "paras": { "LampStatus": "ON" }
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


          this.message = data.result.toString()
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
    let request_url = this.request_url
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
        "service_id": "SmartLamp",
        "command_name": "SetLampStatus",
        "paras": { "LampStatus": "OFF" }
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


          this.message = data.result.toString()
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