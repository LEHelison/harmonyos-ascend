import http from '@ohos.net.http';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'




  build() {
    Row() {
      Column({space:20}) {

        Button('开灯')
          .borderRadius(8).backgroundColor(0x317aff)
          .width(150).margin(10)
          .onClick(()=>{
            console.log("查看数据")
            this.getHttpData1("service_id")
          })
        Button('关灯')
          .borderRadius(8).backgroundColor(0x317aff)
          .width(150).margin(10)
          .onClick(()=>{
            console.log("查看数据")
            this.getHttpData2("service_id")
          })


        Text("消息："+this.message).fontSize(20)

      }
      .width('100%')
    }
    .height('100%')
  }

  request_url: string = "https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/671ef76965629b34009b20f9_Lamp01/commands"
  getHttpData1(type: string) {//进行网络请求
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
        'X-Auth-Token': "MIIN4QYJKoZIhvcNAQcCoIIN0jCCDc4CAQExDTALBglghkgBZQMEAgEwggvzBgkqhkiG9w0BBwGgggvkBIIL4HsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDMtMTVUMDM6Mjc6MTYuNzE0MDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wYW5ndSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3dlbGlua2JyaWRnZV9lbmRwb2ludF9idXkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1yb2NrZXRtcTUtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMta2Fma2EzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlY19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3VuaWJ1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl92bXdhcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZG1lX21ibV9mb3VuZGF0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2M2YSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX211bHRpX2JpbmQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fY2FsbG5vdGlmeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTNkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19wcm9ncmVzc2JhciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nlc19yZXNvdXJjZWdyb3VwX3RhZyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vZmZsaW5lX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19yZXR5cGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9rb29tYXAiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfZXNzZDIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtYW1xcC1iYXNpYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19wb29sX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1zb3V0aHdlc3QtMmIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2NwaCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vZmZsaW5lX2Rpc2tfNCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3ZGV2IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX3dlbGlua3JlZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h2X3ZlbmRvciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2hlY3NfeCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9maWxlc19iYWNrdXAiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXBzIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlX2FsbCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9yb3VuZHRhYmxlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2V4dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Bmc19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfcnUtbW9zY293LTFiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hcHBzdGFnZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2FwcGxpY2F0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2NvbGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9yZHNfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZ3B1X2c1ciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29wX2dhdGVkX21lc3NhZ2VvdmVyNWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfcmkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW5vcnRod2VzdC0yYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2llZl9wbGF0aW51bSIsImlkIjoiMCJ9XSwiaXNzdWVkX2F0IjoiMjAyNS0wMy0xNFQwMzoyNzoxNi43MTQwMDBaIiwidXNlciI6eyJkb21haW4iOnsibmFtZSI6InpocjE2OC0iLCJpZCI6ImVhNjZiODI1MjQ0MTRmYWVhNDg5YTFjZDBhODlkNjkwIn0sIm5hbWUiOiJ5d2IiLCJwYXNzd29yZF9leHBpcmVzX2F0IjoiIiwiaWQiOiI3ZDAzNzIxMGNjZmQ0OGM1YjY4OTgzMDZkYTcyNzIxNSJ9fX0xggHBMIIBvQIBATCBlzCBiTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwIU2hlblpoZW4xLjAsBgNVBAoMJUh1YXdlaSBTb2Z0d2FyZSBUZWNobm9sb2dpZXMgQ28uLCBMdGQxDjAMBgNVBAsMBUNsb3VkMRMwEQYDVQQDDApjYS5pYW0ucGtpAgkA3LMrXRBhahAwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFBOKa83ZngHuz5myPvfo9hCL-VVLUWjUgM9ar4x5zrphA9E4hzWIR+mbXf45h-dxWjnb0NJ9s0H0g5dNXJaEK-7qn161Gn3YA6vu9umqLo+Qanyt5PuHZAAms67YBAk4QioKGeBTPHyDcYJaagt5do4s5P4dbF+5ICGl52ZtS0ki2mvqY9Tu5U9jtCux5-BiG1kKP+6J9hwJ4wlsCV9XZjXpOEzGZza60F2GOqG7wpqvNpQlWROSYCMJmyS6vUpCATvTukqkxXeZ7zYK+zdAOR+g8tk6ycqwOpTp1SZchd1C0yOMi-gqMgD0D4aYX-EpDb6rJlvMoC1vdN7IWgeCto="
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
  getHttpData2(type: string) {//进行网络请求
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
        'X-Auth-Token': "MIIOPgYJKoZIhvcNAQcCoIIOLzCCDisCAQExDTALBglghkgBZQMEAgEwggxQBgkqhkiG9w0BBwGgggxBBIIMPXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjQtMTItMjhUMDI6NDk6MjIuODU1MDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiY2F0YWxvZyI6W10sInJvbGVzIjpbeyJuYW1lIjoidGVfYWRtaW4iLCJpZCI6IjAifSx7Im5hbWUiOiJ0ZV9hZ2VuY3kiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3JlcF9hY2NlbGVyYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfZGlza0FjYyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rzc19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWVwX2FyY2hpdmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRoLTRjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZGVjX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19vbGRfcmVvdXJjZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19Sb3lhbHR5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1lYXN0LTVjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcGFuZ3UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VkZ2VzZWNfb2J0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlY19tb250aCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3VuaWJ1eSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2lkbWVfbWJtX2ZvdW5kYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYzZhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1lYXN0LTViIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9jYWxsbm90aWZ5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtM2QiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2tvb21hcCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19lc3NkMiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Rtcy1hbXFwLWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX3Bvb2xfY2EiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLXNvdXRod2VzdC0yYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2h3Y3BoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tbm9ydGgtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfaGVjc194IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sInByb2plY3QiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoiY24tbm9ydGgtNCIsImlkIjoiZDI0MzQ4YWRkNWNiNDVhMGE2M2VlZTU2MzY0NTQ1YTAifSwiaXNzdWVkX2F0IjoiMjAyNC0xMi0yN1QwMjo0OToyMi44NTUwMDBaIiwidXNlciI6eyJkb21haW4iOnsibmFtZSI6InpocjE2OC0iLCJpZCI6ImVhNjZiODI1MjQ0MTRmYWVhNDg5YTFjZDBhODlkNjkwIn0sIm5hbWUiOiJ5d2IiLCJwYXNzd29yZF9leHBpcmVzX2F0IjoiIiwiaWQiOiI3ZDAzNzIxMGNjZmQ0OGM1YjY4OTgzMDZkYTcyNzIxNSJ9fX0xggHBMIIBvQIBATCBlzCBiTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwIU2hlblpoZW4xLjAsBgNVBAoMJUh1YXdlaSBTb2Z0d2FyZSBUZWNobm9sb2dpZXMgQ28uLCBMdGQxDjAMBgNVBAsMBUNsb3VkMRMwEQYDVQQDDApjYS5pYW0ucGtpAgkA3LMrXRBhahAwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADmRKr3nVz30bz48s8u9S2aPQMzjPZOAlFRTmzlbIhZ1jMVaePDWCoE7aHYaeMg2HGWvyypgAM7kZ2WivBFPbeE57a28g9qyvH+DpCITMC6Oq8SsChtCsuXth4KPRonBClADtNIP0fFO5ca-1FKiGMpg1jlAj79izecjQ4wFFg9xnM4qSlR+GcyWcOt-MxOQ20cqtndeQFyf-AKjIXvwuMcYRoWAOltxhi5J1pDBuHA82m36cDcWERecc6DQNLfUyrPk+pR6PgR8QnZ0O1K5xJLTDY7PphiWvnOg4ezqM43vFFu0szZiILLam2ngFEfLa2sZfJnxjHMajRUL5Rj63Us="
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

