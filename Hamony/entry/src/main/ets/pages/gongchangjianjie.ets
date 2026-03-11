import { router } from '@kit.ArkUI';

@Entry
@Component
struct Gongchangjianjie {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Row() {
        Button('<')
          .width(60)
          .height(36)
          .fontSize(18)
          .fontColor('#007AFF')
          .backgroundColor('#F0F8FF')
          .borderRadius(18)
          .onClick(() => {
            console.log('点击事件触发');
            router.pushUrl({url:'pages/zhu'})
          })

        Text('工厂简介')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({left:-50})


      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .shadow({
        radius: 4,
        color: '#1F000000',
        offsetX: 0,
        offsetY: 2
      })

      Text('智慧工厂是现代制造业发展的高级阶段，融合了物联网、大数据、人工智能、自动化控制等多种先进技术，通过全面的互联互通和智能化决策，实现生产过程的高效、灵活、精益和可持续发展。 \n')
        .fontSize(22)

    }
    .height('100%')
    .width('100%')
  }
}