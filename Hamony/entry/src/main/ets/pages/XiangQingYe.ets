import { App, router } from '@kit.ArkUI';

@Entry
@Component
struct XiangQingYe {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Row() {
        Image($r('app.media.fanhui2'))
          .width(35)
          .height(35)
          .onClick(() => {
            router.pushUrl({ url: 'pages/baojing' })
          })
        Text('详情页')
          .margin({left:80})
          .fontSize(30)
      }
      .width('90%')
      .height(50)

      Tabs() {
        TabContent() {
          Column({ space: 20 }) {

            Row() {
              Text('空气温度：26')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#ffb9f3e8')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)
            Row() {
              Text('空气湿度：16%')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#ffb6e9bb')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text('PM2.5：150微克')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/gaojing' })
            })
            .backgroundColor('#fff6a497')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text('噪音：95dB')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#fff3ebb8')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

          }

          .height('100%')
          .width('100%')
          .backgroundImage($r('app.media.img'))
          .backgroundImageSize({ width: '100%', height: '100%' })
        }
        .tabBar('厂区一')

        TabContent() {
          Column({ space: 20 }) {

            Row() {
              Text('空气温度：26')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#ffb9f3e8')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)
            Row() {
              Text('空气湿度：16%')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#ffb6e9bb')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text('PM2.5：150微克')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/gaojing' })
            })
            .backgroundColor('#fff6a497')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text('噪音：95dB')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#fff3ebb8')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

          }

          .height('100%')
          .width('100%')
          .backgroundImage($r('app.media.img'))
          .backgroundImageSize({ width: '100%', height: '100%' })
        }
        .tabBar('厂区二')

        TabContent() {
          Column({ space: 20 }) {

            Row() {
              Text('空气温度：26')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#ffb9f3e8')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)
            Row() {
              Text('空气湿度：16%')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#ffb6e9bb')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text('PM2.5：150微克')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/gaojing' })
            })
            .backgroundColor('#fff6a497')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text('噪音：95dB')
                .fontSize(20)
              Text('正常')
                .fontSize(20)
            }
            .backgroundColor('#fff3ebb8')
            .borderRadius(20)
            .width('90%')
            .height(140)
            .justifyContent(FlexAlign.SpaceAround)

          }

          .height('100%')
          .width('100%')
          .backgroundImage($r('app.media.img'))
          .backgroundImageSize({ width: '100%', height: '100%' })
        }
        .tabBar('厂区三')
      }
      /* .width('100%')
       .height('100%')
       .backgroundImage($r("app.media.img"))
       .backgroundImageSize({ width: '100%', height: '100%' })*/
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}