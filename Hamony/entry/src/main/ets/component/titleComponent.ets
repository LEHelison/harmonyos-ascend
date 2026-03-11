import { router } from '@kit.ArkUI'

@Preview
@Component
export struct titleComponent {
  name : string =''
  build() {
    Column(){
      Row(){
        Image($r('app.media.fanhui'))
          .width(30)
          .onClick(() => {
            router.back()
          })
        Text(' ' + this.name)
          .fontSize(25)

      }
      .width('90%')
      .margin({top: 10,bottom: 10})

      Divider()
    }
  }
}