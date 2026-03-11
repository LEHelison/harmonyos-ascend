import http from '@ohos.net.http';
import {NoiseModule} from '../yingjian/NoiseModule'
@Entry
@Component
struct Index {
  @State Threshold: string = ''
  @State noisemodule:NoiseModule = new NoiseModule()


  build() {
    Row() {
      Column({space:20}) {
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
        .width("90%")

        Button('查看噪音值')
          .borderRadius(8).backgroundColor(0x317aff)
          .width(150).margin(10)
          .onClick(()=>{
            console.log("查看数据")
            this.getHttpData()
          })


        Text("阈值为："+this.noisemodule.shadow[0]?.reported?.properties?.Threshold)
        Text("检测的噪音值为："+this.noisemodule.shadow[0]?.reported?.properties?.NoiseVolume)


      }
      .width('100%')
    }
    .height('100%')
  }


  getHttpData() {//进行网络请求
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
        'X-Auth-Token': "MIINtAYJKoZIhvcNAQcCoIINpTCCDaECAQExDTALBglghkgBZQMEAgEwggvGBgkqhkiG9w0BBwGgggu3BIILs3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjQtMTItMjlUMDI6NTE6MjQuNTk5MDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wYW5ndSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3dlbGlua2JyaWRnZV9lbmRwb2ludF9idXkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1yb2NrZXRtcTUtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMta2Fma2EzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWRnZXNlY19vYnQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfdW5pYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXBzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlX2FsbCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9yb3VuZHRhYmxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2V4dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Bmc19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbW9zY293LTFiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hcHBzdGFnZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2FwcGxpY2F0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2NvbGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9yZHNfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZ3B1X2c1ciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX21lc3NhZ2VvdmVyNWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfcmkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW5vcnRod2VzdC0yYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2llZl9wbGF0aW51bSIsImlkIjoiMCJ9XSwiaXNzdWVkX2F0IjoiMjAyNC0xMi0yOFQwMjo1MToyNC41OTkwMDBaIiwidXNlciI6eyJkb21haW4iOnsibmFtZSI6InpocjE2OC0iLCJpZCI6ImVhNjZiODI1MjQ0MTRmYWVhNDg5YTFjZDBhODlkNjkwIn0sIm5hbWUiOiJ5d2IiLCJwYXNzd29yZF9leHBpcmVzX2F0IjoiIiwiaWQiOiI3ZDAzNzIxMGNjZmQ0OGM1YjY4OTgzMDZkYTcyNzIxNSJ9fX0xggHBMIIBvQIBATCBlzCBiTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwIU2hlblpoZW4xLjAsBgNVBAoMJUh1YXdlaSBTb2Z0d2FyZSBUZWNobm9sb2dpZXMgQ28uLCBMdGQxDjAMBgNVBAsMBUNsb3VkMRMwEQYDVQQDDApjYS5pYW0ucGtpAgkA3LMrXRBhahAwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABLV-BgXrQHxUN+4l34ge1ec0AvdrgC7eWmb-0jjR9BEeFRr1f8a+X9DunxK47SUnCxbONrH4a-pzbGZtvmp18DDtPAysn8WpCpfnz8TTD4JKAYbHl9b9b8l1uF1ujwYRWUh6IzFR17JJtf9eqkopnmm20VveOwIclpOHwg3cOiY6iZP24XdNqDP7Czv1vBE-a+A+k2HnozB194zvpZQKVqEAvvxJT4G0udC-F+FQW5sId8UdWFZ+cHcelTPBOdL33rHz35DNKNDv6iHBLp0ADZDVKEyHm+bShfiNl4ibH39LcogXpsf1rJt495L-l40hR-MB9O-fR43ErVmIW96+kI="
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
  getHttpData2() {//进行网络请求
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
        'X-Auth-Token': "MIINtAYJKoZIhvcNAQcCoIINpTCCDaECAQExDTALBglghkgBZQMEAgEwggvGBgkqhkiG9w0BBwGgggu3BIILs3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjQtMTItMjlUMDI6NTE6MjQuNTk5MDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wYW5ndSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3dlbGlua2JyaWRnZV9lbmRwb2ludF9idXkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1yb2NrZXRtcTUtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMta2Fma2EzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWRnZXNlY19vYnQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVjX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfdW5pYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXBzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlX2FsbCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9yb3VuZHRhYmxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2V4dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Bmc19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbW9zY293LTFiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hcHBzdGFnZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2FwcGxpY2F0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2NvbGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9yZHNfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZ3B1X2c1ciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX21lc3NhZ2VvdmVyNWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfcmkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW5vcnRod2VzdC0yYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2llZl9wbGF0aW51bSIsImlkIjoiMCJ9XSwiaXNzdWVkX2F0IjoiMjAyNC0xMi0yOFQwMjo1MToyNC41OTkwMDBaIiwidXNlciI6eyJkb21haW4iOnsibmFtZSI6InpocjE2OC0iLCJpZCI6ImVhNjZiODI1MjQ0MTRmYWVhNDg5YTFjZDBhODlkNjkwIn0sIm5hbWUiOiJ5d2IiLCJwYXNzd29yZF9leHBpcmVzX2F0IjoiIiwiaWQiOiI3ZDAzNzIxMGNjZmQ0OGM1YjY4OTgzMDZkYTcyNzIxNSJ9fX0xggHBMIIBvQIBATCBlzCBiTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwIU2hlblpoZW4xLjAsBgNVBAoMJUh1YXdlaSBTb2Z0d2FyZSBUZWNobm9sb2dpZXMgQ28uLCBMdGQxDjAMBgNVBAsMBUNsb3VkMRMwEQYDVQQDDApjYS5pYW0ucGtpAgkA3LMrXRBhahAwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABLV-BgXrQHxUN+4l34ge1ec0AvdrgC7eWmb-0jjR9BEeFRr1f8a+X9DunxK47SUnCxbONrH4a-pzbGZtvmp18DDtPAysn8WpCpfnz8TTD4JKAYbHl9b9b8l1uF1ujwYRWUh6IzFR17JJtf9eqkopnmm20VveOwIclpOHwg3cOiY6iZP24XdNqDP7Czv1vBE-a+A+k2HnozB194zvpZQKVqEAvvxJT4G0udC-F+FQW5sId8UdWFZ+cHcelTPBOdL33rHz35DNKNDv6iHBLp0ADZDVKEyHm+bShfiNl4ibH39LcogXpsf1rJt495L-l40hR-MB9O-fR43ErVmIW96+kI="
      },

      extraData: {
        "service_id": "NoiseDetection",
        "command_name": "SetThreshold",
        "paras": { "Threshold": Number(this.Threshold) }
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

