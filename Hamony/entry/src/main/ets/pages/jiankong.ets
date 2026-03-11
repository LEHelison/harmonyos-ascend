import router from '@ohos.router';
@Entry
@Component
export default struct jiankong{
  build() {
    Column(){

      Row(){
        Image($r('app.media.fanhui1'))
          .width(50)
          .onClick(()=>{
            router.pushUrl({url:'pages/zhu'})
          })
          .width(25)
          .margin({left:0,top:-5})
        Text('工厂监控')
          .fontSize(28)
          .fontWeight(800)
          .margin({left:20})
        Image($r('app.media.shebei'))
          .width(35)
          .margin({left:75,top:-10})
        Text('添加设备')
          .border({width:1,color:Color.Black})
          .margin({left:20,top:-1})
        // .onClick(()=>{
        //   router.pushUrl({url:'pages/jiankongliebiao'})
        // })
      }
      .width('100%')
      .height(50)
      .backgroundColor('#D3D3D3')

      Row(){

        Column(){

          Swiper(){
            Image($r("app.media.jk1"))
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/bangongqu'})
          })

          .width("100%")
          .height(150)

          Row(){
            Text('厂区一')
              .fontSize(25)
          }
          .width('100%')
          .height(25)
          .justifyContent(FlexAlign.Center)

        }
        .width('49%')
        .height(180)

        Column(){
          Swiper(){
            Image($r("app.media.jk5"))
            Image($r("app.media.jk6"))
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/pinzhibu'})
          })
          .width("100%")
          .height(150)

          Row(){
            Text('厂区二')
              .fontSize(25)
          }
          .width('100%')
          .height(25)
          .justifyContent(FlexAlign.Center)
        }
        .width('49%')
        .height(180)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      // .backgroundColor('#D3D3D3')
      .width('100%')
      .height(180)


      Row(){
        Column(){
          Swiper(){
            Image($r("app.media.jk9"))
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/shengchanbu'})
          })
          .width("100%")
          .height(150)

          Row(){
            Text('厂区三')
              .fontSize(25)
          }
          .width('100%')
          .height(25)
          .justifyContent(FlexAlign.Center)

        }
        .width('49%')
        .height(180)
        Column(){
          Swiper(){
            Image($r("app.media.jk12"))
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/shichangbu'})
          })
          .width("100%")
          .height(150)

          Row(){
            Text('厂区四')
              .fontSize(25)
          }
          .width('100%')
          .height(25)
          .justifyContent(FlexAlign.Center)

        }
        .width('49%')
        .height(180)
        // .backgroundColor(Color.Red)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(200)

      Row(){
        Column(){
          Swiper(){
            Image($r("app.media.jk15"))
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/shiyanshi'})
          })
          .width("100%")
          .height(150)
          Row(){
            Text('厂区五')
              .fontSize(25)
          }
          .width('100%')
          .height(25)
          .justifyContent(FlexAlign.Center)
        }
        .width('49%')
        .height(180)
        Column(){
          Swiper(){
            Image($r("app.media.gc2"))
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/xiaoshoubu'})
          })
          .width("100%")
          .height(150)
          Row(){
            Text('厂区六')
              .fontSize(25)
          }
          .width('100%')
          .height(25)
          .justifyContent(FlexAlign.Center)
        }
        .width('49%')
        .height(180)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(180)


    }
    .width('100%')
    .height('100%')
  }
}