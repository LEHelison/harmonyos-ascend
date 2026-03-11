import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = ''

  // 视频流相关状态变量
  @State cameraConnected: boolean = true;
  @State videoStreamUrl: string = 'http://192.168.31.30:5000/video_feed';
  @State isFullScreen: boolean = false;
  @State currentTime: string = '';
  private webController: WebController = new WebController();

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
    const seconds = now.getSeconds().toString().padStart(2, '0')
    this.currentTime = `${hours}:${minutes}:${seconds}`
  }

  build() {
    Column() {
      // 顶部导航栏
      this.buildHeader()

      // 视频监控区域
      this.buildCameraMonitor()

      // 控制按钮区域
      Column({space: 10}){
        Button('前进')
          .backgroundColor('#2196F3')
          .margin({top:6})
          .width(70)
          .type(ButtonType.Circle)
          .onClick(() => {
            this.connectSSH()
          })

        Row(){
          Button('左转')
            .backgroundColor('#2196F3')
            .width(70)
            .type(ButtonType.Circle)
            .onClick(() => {
              this.connectSSH2()
            })

          Button('踏步')
            .onClick(() => {
              this.connectSSH4()
            })
            .type(ButtonType.Circle)
            .fontSize(25)
            .width(90)
            .backgroundColor('#bcff9822')
            .padding(5)
          Button('右转')
            .backgroundColor('#2196F3')
            .width(70)
            .type(ButtonType.Circle)
            .onClick(() => {
              this.connectSSH3()
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Button('后退')
          .backgroundColor('#2196F3')
          .width(70)
          .type(ButtonType.Circle)
          .onClick(() => {
            this.connectSSH1()
          })
      }
      .height('39%')
      .width('90%')
      .borderColor(Color.White)
      .borderRadius(15)
      .borderWidth(10)
      .margin({ top: 20 })

      // 全屏视频遮罩
      if (this.isFullScreen) {
        this.buildFullScreenVideo()
      }
    }
    .backgroundImage($r('app.media.img'))
    .backgroundImageSize({width:'100%',height:'100%'})
    .height('100%')
    .width('100%')
  }

  @Builder
  buildHeader() {
    Row() {
      Button('←')
        .width(50)
        .height(36)
        .fontSize(18)
        .fontColor('#1A1A1A')
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .borderRadius(18)
        .onClick(() => {
          router.back()
        })

      Text('机械狗操作')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontColor('#1A1A1A')

      Text(this.currentTime)
        .fontSize(12)
        .fontColor('#666666')
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .borderRadius(10)
    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 10 })
  }

  @Builder
  buildCameraMonitor() {
    Column() {
      // 监控标题栏
      Row() {
        Row() {
          Circle({ width: 8, height: 8 })
            .fill(this.cameraConnected ? '#00C853' : '#FF3B30')
            .margin({ right: 6 })

          Text(this.cameraConnected ? 'LIVE' : 'OFFLINE')
            .fontSize(12)
            .fontColor(this.cameraConnected ? '#00C853' : '#FF3B30')
            .fontWeight(FontWeight.Bold)
        }

        Blank()

        Text('192.168.18.37')
          .fontSize(10)
          .fontColor('#666666')
          .backgroundColor('rgba(255, 255, 255, 0.6)')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(8)
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 视频显示区域
      Stack() {
        if (this.cameraConnected) {
          // 使用Web组件显示视频流
          Web({
            src: this.videoStreamUrl,
            controller: this.webController
          })
            .width('100%')
            .height(180)
            .borderRadius(12)
            .onPageEnd(() => {
              console.info('Video stream loaded successfully')
            })
            .onErrorReceive((event) => {
              if (event && event.error) {
                console.error('Video stream error:', event.error)
              }
              this.cameraConnected = false
              promptAction.showToast({
                message: '视频流连接失败',
                duration: 2000
              })
            })
            .domStorageAccess(true)
            .mediaPlayGestureAccess(true)
            .multiWindowAccess(false)
            .horizontalScrollBarAccess(false)
            .verticalScrollBarAccess(false)
        } else {
          // 连接失败时的占位界面
          Column() {
            Text('📹')
              .fontSize(48)
              .fontColor('#CCCCCC')
              .margin({ bottom: 12 })

            Text('摄像头离线')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ bottom: 8 })

            Text('192.168.18.37:5000')
              .fontSize(12)
              .fontColor('#999999')
              .margin({ bottom: 12 })

            Button('重新连接')
              .fontSize(12)
              .backgroundColor('#007AFF')
              .fontColor(Color.White)
              .borderRadius(16)
              .padding({ left: 16, right: 16, top: 6, bottom: 6 })
              .onClick(() => {
                this.reconnectCamera()
              })
          }
          .width('100%')
          .height(180)
          .backgroundColor('rgba(245, 245, 245, 0.8)')
          .borderRadius(12)
          .border({
            width: 1,
            color: 'rgba(0, 0, 0, 0.1)'
          })
          .justifyContent(FlexAlign.Center)
        }

        // 控制按钮层
        if (this.cameraConnected) {
          Column() {
            Row() {
              // 信号强度指示
              Row() {
                Text('●●●')
                  .fontSize(8)
                  .fontColor('#00C853')
                  .backgroundColor('rgba(0, 0, 0, 0.6)')
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  .borderRadius(8)
              }

              Blank()

              // 全屏按钮
              Button('⛶')
                .width(32)
                .height(32)
                .fontSize(16)
                .backgroundColor('rgba(0, 0, 0, 0.6)')
                .fontColor(Color.White)
                .borderRadius(16)
                .onClick(() => {
                  this.isFullScreen = true
                })

              // 录制按钮
              Button('⏺')
                .width(32)
                .height(32)
                .fontSize(16)
                .backgroundColor('rgba(255, 59, 48, 0.8)')
                .fontColor(Color.White)
                .borderRadius(16)
                .margin({ left: 8 })
                .onClick(() => {
                  this.startRecording()
                })
            }
            .width('100%')
            .padding(12)

            Blank()

            // 时间戳和分辨率信息
            Column() {
              Text(this.currentTime)
                .fontSize(12)
                .fontColor(Color.White)
                .backgroundColor('rgba(0, 0, 0, 0.6)')
                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                .borderRadius(8)
                .margin({ bottom: 4 })

              Text('1920×1080')
                .fontSize(10)
                .fontColor(Color.White)
                .backgroundColor('rgba(0, 0, 0, 0.6)')
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .borderRadius(6)
            }
            .alignItems(HorizontalAlign.End)
            .margin({ bottom: 12, right: 12 })
            .alignSelf(ItemAlign.End)
          }
          .width('100%')
          .height('100%')
        }
      }
      .width('100%')
      .height(180)
      .margin({ bottom: 16 })

      // 摄像头控制面板
      Row() {
        Button('截图')
          .fontSize(12)
          .backgroundColor('rgba(255, 255, 255, 0.8)')
          .fontColor('#007AFF')
          .borderRadius(16)
          .border({ width: 1, color: '#007AFF' })
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .onClick(() => {
            this.takeSnapshot()
          })

        Button('画质')
          .fontSize(12)
          .backgroundColor('rgba(255, 255, 255, 0.8)')
          .fontColor('#007AFF')
          .borderRadius(16)
          .border({ width: 1, color: '#007AFF' })
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .onClick(() => {
            this.adjustQuality()
          })

        Button('刷新')
          .fontSize(12)
          .backgroundColor('rgba(255, 255, 255, 0.8)')
          .fontColor('#007AFF')
          .borderRadius(16)
          .border({ width: 1, color: '#007AFF' })
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .onClick(() => {
            this.refreshVideoStream()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('90%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ bottom: 16 })
  }

  @Builder
  buildFullScreenVideo() {
    Stack() {
      // 黑色背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#000000')

      // 全屏视频
      Column() {
        if (this.cameraConnected) {
          Web({
            src: this.videoStreamUrl,
            controller: this.webController
          })
            .width('100%')
            .height('100%')
            .backgroundColor('#000000')
        }

        // 控制栏
        Row() {
          Button('退出全屏')
            .backgroundColor('rgba(0, 0, 0, 0.6)')
            .fontColor(Color.White)
            .borderRadius(20)
            .onClick(() => {
              this.isFullScreen = false
            })

          Blank()

          Text(this.currentTime)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('rgba(0, 0, 0, 0.6)')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(12)
        }
        .width('100%')
        .position({ x: 0, y: 40 })
        .padding({ left: 20, right: 20 })
        .zIndex(1)
      }
    }
    .zIndex(1000)
  }

  // 视频流相关方法
  private reconnectCamera(): void {
    this.cameraConnected = false
    promptAction.showToast({
      message: '正在重新连接...',
      duration: 1000
    })

    setTimeout(() => {
      this.cameraConnected = true
      this.webController.refresh()
      promptAction.showToast({
        message: '摄像头重新连接成功',
        duration: 2000
      })
    }, 2000)
  }

  private refreshVideoStream(): void {
    promptAction.showToast({
      message: '正在刷新视频流...',
      duration: 1000
    })
    this.webController.refresh()
  }

  private takeSnapshot(): void {
    this.webController.runJavaScript({
      script: 'document.querySelector("img") ? document.querySelector("img").src : ""',
      callback: (result: string) => {
        if (result) {
          promptAction.showToast({
            message: '截图已保存',
            duration: 2000
          })
        } else {
          promptAction.showToast({
            message: '截图功能暂不可用',
            duration: 2000
          })
        }
      }
    })
  }

  private adjustQuality(): void {
    AlertDialog.show({
      title: '画质设置',
      message: '选择视频画质',
      primaryButton: {
        value: '高清',
        action: () => {
          promptAction.showToast({
            message: '已切换到高清模式',
            duration: 2000
          })
        }
      },
      secondaryButton: {
        value: '标清',
        action: () => {
          promptAction.showToast({
            message: '已切换到标清模式',
            duration: 2000
          })
        }
      }
    })
  }

  private startRecording(): void {
    promptAction.showToast({
      message: '开始录制视频',
      duration: 2000
    })
  }

  //前进
  connectSSH(): void {
    let httpRequest = http.createHttp()
    let URL = 'http://192.168.30.219:5000/forward'
    httpRequest.request(URL,{
      method: http.RequestMethod.GET,
    }).then((data: http.HttpResponse) => {
      console.info('SSH connect success:'+JSON.stringify(data))
      this.message = JSON.stringify(data)
    }).catch((err: BusinessError) => {
      console.info('SSH connect error: ' + JSON.stringify(err))
      this.message = 'SSH connect error: ' + JSON.stringify(err)
    })
  }
  //后退
  connectSSH1(): void {
    let httpRequest = http.createHttp()
    let URL = 'http://192.168.30.219:5000/backward'
    httpRequest.request(URL,{
      method: http.RequestMethod.GET,
    }).then((data: http.HttpResponse) => {
      console.info('SSH connect success:'+JSON.stringify(data))
      this.message = JSON.stringify(data)
    }).catch((err: BusinessError) => {
      console.info('SSH connect error: ' + JSON.stringify(err))
      this.message = 'SSH connect error: ' + JSON.stringify(err)
    })
  }
  //向左
  connectSSH2(): void {
    let httpRequest = http.createHttp()
    let URL = 'http://192.168.30.219:5000/left'
    httpRequest.request(URL,{
      method: http.RequestMethod.GET,
    }).then((data: http.HttpResponse) => {
      console.info('SSH connect success:'+JSON.stringify(data))
      this.message = JSON.stringify(data)
    }).catch((err: BusinessError) => {
      console.info('SSH connect error: ' + JSON.stringify(err))
      this.message = 'SSH connect error: ' + JSON.stringify(err)
    })
  }
  //向右
  connectSSH3(): void {
    let httpRequest = http.createHttp()
    let URL = 'http://192.168.30.219:5000/right'
    httpRequest.request(URL,{
      method: http.RequestMethod.GET,
    }).then((data: http.HttpResponse) => {
      console.info('SSH connect success:'+JSON.stringify(data))
      this.message = JSON.stringify(data)
    }).catch((err: BusinessError) => {
      console.info('SSH connect error: ' + JSON.stringify(err))
      this.message = 'SSH connect error: ' + JSON.stringify(err)
    })
  }
  //踏步
  connectSSH4(): void {
    let httpRequest = http.createHttp()
    let URL = 'http://192.168.30.219:5000/step'
    httpRequest.request(URL,{
      method: http.RequestMethod.GET,
    }).then((data: http.HttpResponse) => {
      console.info('SSH connect success:'+JSON.stringify(data))
      this.message = JSON.stringify(data)
    }).catch((err: BusinessError) => {
      console.info('SSH connect error: ' + JSON.stringify(err))
      this.message = 'SSH connect error: ' + JSON.stringify(err)
    })
  }

}