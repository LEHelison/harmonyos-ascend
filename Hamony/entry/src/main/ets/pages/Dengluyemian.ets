import router from '@ohos.router'
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
@Entry
@Component
struct Dengluyemian {

  @State message: string = 'Hello World'

  Num:string='zhr'
  pw:string='12345678'
  @State username:string=''
  @State passward:string=''

  build() {
    Column({space:10}){//space:每一行空间为10
      Image($r("app.media.xl"))
        .width(80)
        .height(80)
        .borderRadius(50)
        .margin({
          top:"120vp"
        })
      Text("欢迎登录")
        .fontColor(Color.Gray)
        .fontSize(24)
        .margin({
          top:"20vp"
        })
      TextInput({placeholder:"请输入用户名称"})
        .height(50)
        .margin({
          bottom:"10vp"
        })
        .onChange((val)=>{
          this.username=val
        })
      TextInput({placeholder:"请输入密码"})
        .height(50)
        .type(InputType.Password)
        .margin({
          bottom:"10vp"
        })
        .onChange((val)=>{
          this.passward=val
        })
      Row(){
        Button(){
          Text("短信验证码登录")
            .fontColor("#007DFF")
            .fontSize(14)
            .onClick(()=>{
              router.pushUrl({url:'pages/dxyzmjm'})
            })
        }
        .height(15)
        .backgroundColor(Color.Transparent)

        Button(){
          Text("忘记密码")
            .fontColor("#007DFF")
            .fontSize(14)
            .onClick(()=>{
              router.pushUrl({url:"pages/wjmm"})
            })
        }
        .height(15)
        .backgroundColor(Color.Transparent)
      }
      .justifyContent(FlexAlign.SpaceBetween)//横向布局，使其向两侧对齐
      .width("90%")
      .margin({
        bottom:"20vp"
      })
      Button("登录")
        .height(50)
        .width("90%")
        .type(ButtonType.Capsule)
        .onClick(()=>{
          if (this.username=='zhr'&&this.passward=='12345678') {
            promptAction.showToast({
              message:'登录成功！'
            })
            router.pushUrl({url:'pages/zhu'})
          }else {
            if (this.username==''&&this.passward=='') {
              promptAction.showToast({
                message:'请输入账号密码'
              })
            }else {
              promptAction.showToast({
                message:'密码输入错误'
              })
            }
          }
        })
      Button(){
        Text("注册账号")
          .fontColor("#007DFF")
          .fontSize(14)
          .onClick(()=>{
            router.pushUrl({url:'pages/zczh'})
          })
      }
      .margin({
        top:15
      })
      .height(15)
      .backgroundColor(Color.Transparent)
      LoadingProgress()
        .width(50)
        .height(50)
        .color(Color.Blue)

      /* Blank()//将上下页面分开，上边不动，下边靠下
       Row(){
         Line()
           .width("20%")
           .height(0.5)
           .backgroundColor(Color.Black)
         Text("其他登录方式")
           .fontColor(Color.Black)
           .fontSize(14)
           .margin({
             left:"10vp",
             right:"10vp"
           })
         Line()
           .width("20%")
           .height(0.5)
           .backgroundColor(Color.Black)
       }
       Row({space:50}){
         Button(){
           Image($r("app.media.wx"))
             .width(40)
             .height(40)
             .onClick(()=>{
               router.pushUrl({url:"pages/wx"})
             })
         }
         .backgroundColor(Color.Transparent)
         Button(){
           Image($r("app.media.qqyx2"))
             .width(50)
             .height(40)
             .onClick(()=>{
               router.pushUrl({url:"pages/qqyx"})
             })
         }
         .backgroundColor(Color.Transparent)
         Button(){
           Image($r("app.media.qq"))
             .width(40)
             .height(40)
             .onClick(()=>{
               router.pushUrl({url:"pages/qq"})
             })
         }
         .backgroundColor(Color.Transparent)
       }
       .width("100%")
       .justifyContent(FlexAlign.SpaceAround)//横向布局，平均分布
       .margin({
         top:20
       })*/
    }
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'700'})
    .padding({
      left:"10vp",
      right:"10vp",
      bottom:"10vp"
    })
  }
  request_url: string = "123.249.30.1:5000/devices"
  getHttpData(type: string) {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url = this.request_url
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
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