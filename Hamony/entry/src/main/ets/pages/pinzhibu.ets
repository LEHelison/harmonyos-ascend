import router from '@ohos.router';
@Entry
@Component
export default struct yanfabu {
  build() {
    Column() {
      Row() {
        Image($r('app.media.fanhui1'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/zhu' })
          })
          .width(50)
          .width(25)
          .margin({ left: 0, top: -5 })
        Text('工厂监控')
          .fontSize(28)
          .fontWeight(800)
          .margin({ left: 20 })
        Image($r('app.media.shebei'))
          .width(35)
          .margin({ left: 75, top: -10 })
        Text('添加设备')
          .border({ width: 1, color: Color.Black })
          .margin({ left: 20, top: -1 })
      }
      .width('100%')
      .height(50)
      .backgroundColor('#D3D3D3')
      Row(){
        Column(){
          Swiper(){
            Image($r("app.media.jk1"))
          }
          .width("100%")
          .height(550)
        }
        .width('100%')
        .height(550)
        .backgroundColor(Color.Green)
      }
      .width('100%')
      .height(550)
      Row(){
        Text()
        Image($r('app.media.paizhao'))
          .onClick(() =>{
            AlertDialog.show({
              message:'请先连接设备'
            })
          })
          .borderRadius(25)
          .width(50)
          .backgroundColor('#808080')
        Text()
        Image($r('app.media.luxiang'))
          .onClick(() =>{
            AlertDialog.show({
              message:'请先连接设备'
            })
          })
          .width(50)
          .borderRadius(25)
          .backgroundColor('#808080')
        Text()
        Image($r('app.media.yuntai'))
          .onClick(() =>{
            AlertDialog.show({
              message:'请先连接设备'
            })
          })
          .width(50)
          .borderRadius(25)
          .backgroundColor('#808080')
        Text()
        Image($r('app.media.yuyin'))
          .onClick(() =>{
            AlertDialog.show({
              message:'请先连接设备'
            })
          })
          .width(50)
          .borderRadius(25)
          .backgroundColor('#808080')
          .margin({right:20})
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(100)
      .margin({top:50})
      Row(){
        Text('截图')
          .margin({left:30})
        Text('录像')
          .margin({left:58})
        Text('云台')
          .margin({left:59})
        Text('语音')
          .margin({left:56})
      }
      .width('100%')
      .height(20)
    }
    .width('100%')
    .height(650)
  }
}