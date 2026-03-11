import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';

@Entry
@Component
struct RobotDetailPage {
  @State productInfo: string = "DOFBOT AI视觉机械臂以树莓派5/JETSON NANO为主控，OpenCV为图像处理库，以主流的Jupyter Lab为开发工具，使用Python为主要编程语言。摄像头与机械臂机身一体式设计，超强的视觉识别让机械臂显得更加灵动；它不仅可以实现颜色识别追踪与抓取，还能人体特征识别互动，甚至进行垃圾分类模型训练垃圾分拣；通过ROS机器人操控系统，简化了6自由度串行总线舱机复杂运动控制。官方提供引导式快速上手教程，助您轻松驾驭DOFBOT AI视觉机械臂。";

  @State isVideoPlaying: boolean = false;
  @State message: string = '';
  @State isLoading: boolean = false;
  @State robotStatus: string = '待机中';
  @State currentTime: string = '';
  @State currentTab: number = 0;
  @State cameraConnected: boolean = true;
  @State videoStreamUrl: string = 'http://192.168.18.37:5000/video_feed';
  @State isFullScreen: boolean = false;
  private videoController: VideoController = new VideoController();
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
    Stack() {
      // 背景图片
      Image($r("app.media.img"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 主要内容
      Column() {
        // 顶部导航栏
        this.buildHeader()

        // 主体内容
        Scroll() {
          Column() {
            // 机器人状态卡片
            this.buildStatusCard()

            // 标签页切换
            this.buildTabSelector()

            // 内容区域
            this.buildContentArea()

            // 控制面板（始终显示）
            this.buildControlPanel()
          }
          .padding({ left: 20, right: 20, bottom: 30 })
        }
        .layoutWeight(1)
        .backgroundColor('rgba(255, 255, 255, 0.05)')
        .backdropBlur(10)
      }

      // 全屏视频遮罩
      if (this.isFullScreen) {
        this.buildFullScreenVideo()
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  buildHeader() {
    Row() {
      Button('<')
        .width(60)
        .height(36)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .borderRadius(18)
        .onClick(() => {
          router.back()
        })

      Text('机械臂控制中心')
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
  buildStatusCard() {
    Column() {
      Row() {
        Column() {
          Text('机械臂1号')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ bottom: 6 })

          Text('型号: DB-6DOF-V2')
            .fontSize(14)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Column() {
          Row() {
            Circle({ width: 8, height: 8 })
              .fill(this.robotStatus === '运行中' ? '#00C853' : '#757575')
              .margin({ right: 6 })

            Text(this.robotStatus)
              .fontSize(14)
              .fontColor(this.robotStatus === '运行中' ? '#00C853' : '#757575')
              .fontWeight(FontWeight.Medium)
          }
          .margin({ bottom: 6 })

          Text('最后活动: 2分钟前')
            .fontSize(12)
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 关键参数展示
      Row() {
        this.buildParamItem('自由度', '6DOF')
        this.buildParamItem('负载', '250g')
        this.buildParamItem('精度mm', '±1')
        this.buildParamItem('半径mm', '320')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(20)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ top: 20, bottom: 25 })
  }

  @Builder
  buildParamItem(label: string, value: string) {
    Column() {
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#007AFF')
        .margin({ bottom: 4 })

      Text(label)
        .fontSize(12)
        .fontColor('#666666')
    }
    .width(70)
    .height(60)
    .padding(8)
    .backgroundColor('rgba(255, 255, 255, 0.5)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.05)'
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildTabSelector() {
    Row() {
      this.buildTabItem('实时监控', 0)
      this.buildTabItem('功能特性', 1)
      this.buildTabItem('技术规格', 2)
    }
    .width('100%')
    .padding(4)
    .backgroundColor('rgba(255, 255, 255, 0.6)')
    .backdropBlur(15)
    .borderRadius(25)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ bottom: 25 })
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  @Builder
  buildTabItem(title: string, index: number) {
    Text(title)
      .fontSize(12)
      .fontColor(this.currentTab === index ? Color.White : '#666666')
      .backgroundColor(this.currentTab === index ? '#007AFF' : Color.Transparent)
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .borderRadius(20)
      .onClick(() => {
        this.currentTab = index;
      })
  }

  @Builder
  buildContentArea() {
    Column() {
      if (this.currentTab === 0) {
        this.buildVideoSection()
      } else if (this.currentTab === 1) {
        this.buildFeaturesSection()
      } else if (this.currentTab === 2) {
        this.buildSpecsSection()
      }
    }
    .width('100%')
    .margin({ bottom: 25 })
  }

  @Builder
  buildVideoSection() {
    Column() {
      // 摄像头监控区域
      this.buildCameraMonitor()

      // 实时数据监控
      this.buildRealTimeData()
    }
    .width('100%')
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

        Text('192.168.31.12')
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
            src: 'http://192.168.31.30:5000/video_feed',
            controller: this.webController
          })
            .width('100%')
            .height(220)
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

            Text('192.168.31.12:5000')
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
          .height(220)
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
      .height(220)
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
    .width('100%')
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
  buildRealTimeData() {

  }

  @Builder
  buildDataItem(label: string, value: string, color: string) {
    Column() {
      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .margin({ bottom: 4 })

      Text(label)
        .fontSize(12)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('rgba(255, 255, 255, 0.6)')
    .borderRadius(8)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.05)'
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
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
            src: 'http://192.168.31.30:5000/video_feed',
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

  @Builder
  buildFeaturesSection() {
    Column() {
      this.buildFeatureCard('', '颜色识别', '智能识别并抓取不同颜色的物体，支持多种颜色模式')
      this.buildFeatureCard('', '人体识别', '实时检测和跟踪人体特征，支持人机交互')
      this.buildFeatureCard('', '垃圾分类', 'AI驱动的垃圾分类和分拣，环保智能')
      this.buildFeatureCard('', 'ROS系统', '基于ROS操作系统，模块化编程')
    }
    .width('100%')
  }

  @Builder
  buildFeatureCard(icon: string, title: string, description: string) {
    Row() {
      Text(icon)
        .fontSize(20)
        .margin({ right: 16 })

      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ bottom: 6 })

        Text(description)
          .fontSize(14)
          .fontColor('#666666')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ bottom: 12 })
  }

  @Builder
  buildSpecsSection() {
    Column() {
      this.buildSpecRow('主控系统', '树莓派5 / JETSON NANO')
      this.buildSpecRow('图像处理', 'OpenCV 深度学习')
      this.buildSpecRow('开发环境', 'Jupyter Lab + Python')
      this.buildSpecRow('操作系统', 'ROS机器人操作系统')
      this.buildSpecRow('摄像头', '一体式设计，手眼合一')
      this.buildSpecRow('通信方式', '串行总线通信')
      this.buildSpecRow('工作电压', 'DC 12V')
      this.buildSpecRow('重复精度', '±0.5mm')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(20)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
  }

  @Builder
  buildSpecRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor('#666666')
        .width(90)

      Text(value)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
        .textAlign(TextAlign.End)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .border({
      width: { bottom: 1 },
      color: 'rgba(0, 0, 0, 0.1)'
    })
  }

  @Builder
  buildControlPanel() {
    Column() {
      Text('控制面板')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 20 })

      Column({ space: 16 }) {
        Button(this.isLoading ? '启动中...' : '启动机械臂')
          .width('100%')
          .height(52)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.isLoading ? '#CCCCCC' : '#007AFF')
          .fontColor(Color.White)
          .borderRadius(26)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.connectSSH()
          })

        Button('关闭机械臂')
          .width('100%')
          .height(52)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('rgba(255, 255, 255, 0.8)')
          .fontColor('#FF3B30')
          .border({
            width: 2,
            color: '#FF3B30'
          })
          .borderRadius(26)
          .onClick(() => {
            this.stopRobot()
          })

        if (this.isLoading) {
          Row() {
            LoadingProgress()
              .width(20)
              .height(20)
              .color('#007AFF')
              .margin({ right: 8 })

            Text('正在启动机械臂，请稍候...')
              .fontSize(14)
              .fontColor('#666666')
          }
          .justifyContent(FlexAlign.Center)
          .margin({ top: 8 })
        }
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(20)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
  }

  // 摄像头相关方法
  private reconnectCamera(): void {
    this.cameraConnected = false
    promptAction.showToast({
      message: '正在重新连接...',
      duration: 1000
    })

    setTimeout(() => {
      this.cameraConnected = true
      // 刷新Web组件
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

    // 刷新Web组件
    this.webController.refresh()
  }

  private takeSnapshot(): void {
    // 使用正确的参数格式调用runJavaScript
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

  private switchCamera(): void {
    promptAction.showToast({
      message: '切换到侧视角摄像头',
      duration: 2000
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

  connectSSH(): void {
    this.isLoading = true
    let httpRequest = http.createHttp()
    let URL = 'http://192.168.31.30:5001/start_all'

    httpRequest.request(URL, {
      method: http.RequestMethod.GET,
      connectTimeout: 10000,
      readTimeout: 10000
    }).then((data: http.HttpResponse) => {
      console.info('Robot start success:' + JSON.stringify(data))
      this.message = JSON.stringify(data)
      this.robotStatus = '运行中'
      this.isLoading = false

      promptAction.showToast({
        message: '机械臂启动成功',
        duration: 2000
      })
    }).catch((err: BusinessError) => {
      console.error('Robot start error: ' + JSON.stringify(err))
      this.message = 'Robot start error: ' + JSON.stringify(err)
      this.isLoading = false

      AlertDialog.show({
        title: '启动失败',
        message: '机械臂启动失败，请检查网络连接',
        primaryButton: {
          value: '重试',
          action: () => {
            this.connectSSH()
          }
        },
        secondaryButton: {
          value: '取消',
          action: () => {}
        }
      })
    })
  }

  stopRobot(): void {

    this.isLoading = true
    let httpRequest = http.createHttp()
    let URL = 'http://192.168.31.30:5001/stop_all'

    httpRequest.request(URL, {
      method: http.RequestMethod.GET,
      connectTimeout: 10000,
      readTimeout: 10000
    }).then((data: http.HttpResponse) => {
      console.info('Robot start success:' + JSON.stringify(data))
      this.message = JSON.stringify(data)
      this.robotStatus = '运行中'
      this.isLoading = false

      promptAction.showToast({
        message: '机械臂关闭成功',
        duration: 2000
      })
    }).catch((err: BusinessError) => {
      console.error('Robot start error: ' + JSON.stringify(err))
      this.message = 'Robot start error: ' + JSON.stringify(err)
      this.isLoading = false

      AlertDialog.show({
        title: '关闭失败',
        message: '机械臂关闭失败，请检查网络连接',
        primaryButton: {
          value: '重试',
          action: () => {
            this.connectSSH()
          }
        },
        secondaryButton: {
          value: '取消',
          action: () => {}
        }
      })
    })
  }
}