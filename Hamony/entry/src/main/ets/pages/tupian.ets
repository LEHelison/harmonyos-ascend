import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Tupian {
  @State message: string = 'Hello World'
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
    const month = (now.getMonth() + 1).toString().padStart(2, '0')
    const day = now.getDate().toString().padStart(2, '0')
    this.currentTime = `${month}月${day}日 ${hours}:${minutes}`
  }

  build() {
    Stack() {
      // 背景图片
      Image($r("app.media.img"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 主要内容
      Column() {
        // 顶部导航栏
        Row() {
          Button('返回')
            .width(60)
            .height(36)
            .fontSize(14)
            .fontColor('#1A1A1A')
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .borderRadius(18)
            .onClick(() => {
              router.back()
            })

          Text('头像设置')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor('#1A1A1A')


        }
        .width('100%')
        .height(60)
        .padding({ left: 20, right: 20, top: 10 })

        // 主体内容
        Column() {
          // 头像展示区域
          this.buildAvatarSection()

          // 操作按钮区域
          this.buildActionButtons()
        }
        .layoutWeight(1)
        .backgroundColor('rgba(255, 255, 255, 0.05)')
        .backdropBlur(10)
        .padding({ left: 20, right: 20, top: 40, bottom: 40 })
        .justifyContent(FlexAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  buildAvatarSection() {
    Column() {
      Text('当前头像')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ bottom: 30 })

      // 头像展示
      Stack() {
        Image($r('app.media.toux'))
          .width(200)
          .height(200)
          .borderRadius(100)
          .border({
            width: 4,
            color: Color.White
          })

        // 编辑图标
        Circle({ width: 40, height: 40 })
          .fill('#007AFF')
          .position({ x: 160, y: 160 })

        Text('✏️')
          .fontSize(20)
          .fontColor(Color.White)
          .position({ x: 170, y: 170 })
          .onClick(() => {
            this.selectAvatar()
          })
      }
      .width(200)
      .height(200)
      .margin({ bottom: 40 })

      Text('点击头像或下方按钮更换')
        .fontSize(14)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding(30)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(20)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ bottom: 40 })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildActionButtons() {
    Column({ space: 16 }) {
      Button('拍照设置')
        .width('100%')
        .height(52)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#007AFF')
        .fontColor(Color.White)
        .borderRadius(26)
        .onClick(() => {
          this.takePhoto()
        })

      Button('从相册选择')
        .width('100%')
        .height(52)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .fontColor('#007AFF')
        .border({
          width: 2,
          color: '#007AFF'
        })
        .borderRadius(26)
        .onClick(() => {
          this.selectFromGallery()
        })

      Button('使用默认头像')
        .width('100%')
        .height(52)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .fontColor('#666666')
        .border({
          width: 1,
          color: '#CCCCCC'
        })
        .borderRadius(26)
        .onClick(() => {
          this.useDefaultAvatar()
        })
    }
    .width('100%')
  }

  private selectAvatar() {
    AlertDialog.show({
      title: '更换头像',
      message: '请选择头像来源',
      primaryButton: {
        value: '拍照',
        action: () => {
          this.takePhoto()
        }
      },
      secondaryButton: {
        value: '相册',
        action: () => {
          this.selectFromGallery()
        }
      }
    })
  }

  private takePhoto() {
    promptAction.showToast({
      message: '打开相机拍照',
      duration: 2000
    })
  }

  private selectFromGallery() {
    promptAction.showToast({
      message: '打开相册选择',
      duration: 2000
    })
  }

  private useDefaultAvatar() {
    AlertDialog.show({
      title: '确认操作',
      message: '确定要使用默认头像吗？',
      primaryButton: {
        value: '确定',
        action: () => {
          promptAction.showToast({
            message: '已设置为默认头像',
            duration: 2000
          })
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {}
      }
    })
  }
}