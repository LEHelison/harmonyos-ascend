import router from '@ohos.router';
import url from '@ohos.url';

@Entry
@Component
export default struct CustomDialogExample {
  @State currentTime: string = '';

  aboutToAppear() {
    this.updateTime()
    setInterval(() => {
      this.updateTime()
    }, 1000)
  }

  updateTime() {
    const now = new Date()
    const hours = now.getHours().toString().padStart(2, '0')
    const minutes = now.getMinutes().toString().padStart(2, '0')
    this.currentTime = `${hours}:${minutes}`
  }

  build() {
    Column() {
      // 顶部状态栏
      Row() {
        Text('个人中心')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')

        Blank()

        Text(this.currentTime)
          .fontSize(14)
          .fontColor('#1A1A1A')
      }
      .width('100%')
      .height(60)
      .padding({ left: 20, right: 20 })
      .margin({ top: 20, bottom: 20 })

      // 用户信息区域
      Row({ space: 20 }) {
        // 头像
        Image($r("app.media.touxiang"))
          .width(80)
          .height(80)
          .borderRadius(40)
          .onClick(() => {
            router.pushUrl({ url: 'pages/tupian' })
          })

        // 用户信息
        Column({ space: 8 }) {
          Text('管理员')
            .fontWeight(FontWeight.Bold)
            .fontSize(26)
            .fontColor('#1A1A1A')
            .width("100%")
            .textAlign(TextAlign.Start)

          Text('工号：12345678')
            .fontSize(16)
            .fontColor('#7A8A9A')
            .width("100%")
            .textAlign(TextAlign.Start)

          Row() {
            Circle({ width: 8, height: 8 })
              .fill('#4A90E2')
              .margin({ right: 6 })

            Text('在线')
              .fontSize(13)
              .fontColor('#4A90E2')
              .fontWeight(FontWeight.Medium)
          }
          .width("100%")
          .justifyContent(FlexAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ bottom: 40 })

      // 功能菜单列表
      Column() {
        // 工作日志
        Row() {
          Row({ space: 15 }) {
            Image($r('app.media.gongzuorz'))
              .width(28)
              .height(28)

            Text('工作日志')
              .fontSize(18)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)

          Image($r('app.media.jinru'))
            .width(18)
            .height(18)
        }
        .width('100%')
        .height(70)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/gongzuorizhi' })
        })

        Divider()
          .strokeWidth(0.5)
          .width('90%')
          .color('#E5E5E5')

        // 考勤管理
        Row() {
          Row({ space: 15 }) {
            Image($r('app.media.kaoqin'))
              .width(28)
              .height(28)

            Text('考勤管理')
              .fontSize(18)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)

          Image($r('app.media.jinru'))
            .width(18)
            .height(18)
        }
        .width('100%')
        .height(70)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/kaoqin' })
        })

        Divider()
          .strokeWidth(0.5)
          .width('90%')
          .color('#E5E5E5')

        // 问题反馈
        Row() {
          Row({ space: 15 }) {
            Image($r('app.media.tousu'))
              .width(28)
              .height(28)

            Text('问题反馈')
              .fontSize(18)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)

          Image($r('app.media.jinru'))
            .width(18)
            .height(18)
        }
        .width('100%')
        .height(70)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/tousu' })
        })

        Divider()
          .strokeWidth(0.5)
          .width('90%')
          .color('#E5E5E5')

        // 个人详情
        Row() {
          Row({ space: 15 }) {
            Image($r('app.media.xiangqing'))
              .width(28)
              .height(28)

            Text('个人详情')
              .fontSize(18)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)

          Image($r('app.media.jinru'))
            .width(18)
            .height(18)
        }
        .width('100%')
        .height(70)
        .padding({ left: 20, right: 20 })

        Divider()
          .strokeWidth(0.5)
          .width('90%')
          .color('#E5E5E5')

        // 权限管理
        Row() {
          Row({ space: 15 }) {
            Image($r('app.media.quanxian'))
              .width(28)
              .height(28)

            Text('权限管理')
              .fontSize(18)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)

          Image($r('app.media.jinru'))
            .width(18)
            .height(18)
        }
        .width('100%')
        .height(70)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/quanxianguanli' })
        })

        Divider()
          .strokeWidth(0.5)
          .width('90%')
          .color('#E5E5E5')

        // 系统设置
        Row() {
          Row({ space: 15 }) {
            Image($r('app.media.shezhi'))
              .width(28)
              .height(28)

            Text('系统设置')
              .fontSize(18)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)

          Image($r('app.media.jinru'))
            .width(18)
            .height(18)
        }
        .width('100%')
        .height(70)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/yonghu2' })
        })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}