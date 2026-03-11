import router from '@ohos.router';
import http from '@ohos.net.http';
import webview from '@ohos.web.webview';


interface MyObject {
  success: boolean;
  name: string;
  subtitle: string;
  data: Array<Article>;
}

class Article {
  title: string;
  hot: string;
  url: string;
  mobil_url: string;
  index: number;

  constructor(title: string, hot: string, url: string, mobil_url: string, index: number) {
    this.title = title;
    this.hot = hot;
    this.url = url;
    this.mobil_url = mobil_url;
    this.index = index;
  }
}

@Entry
@Component
export default struct ceshi {
  @State message: string[] = ['等待打卡...', '暂未设置', '00:00:00', '40小时30分钟'];
  @State currentTime: string = '';
  @State isClockingIn: boolean = false;
  @State clockStatus: string = '未打卡';
  @State todayWorkTime: string = '07:30:00';

  webController: webview.WebviewController = new webview.WebviewController();

  obj = {
    success: false,
    name: "hello"
  } as MyObject;
  @State articleList: Array<Article> = []

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
    const month = (now.getMonth() + 1).toString().padStart(2, '0')
    const day = now.getDate().toString().padStart(2, '0')
    this.currentTime = `${month}月${day}日 ${hours}:${minutes}:${seconds}`
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
            // 时间显示区域
            this.buildTimeSection()

            // 打卡区域
            this.buildClockInSection()

            // 考勤统计
            this.buildAttendanceStats()

            // 考勤记录
            this.buildAttendanceRecords()
          }
          .padding({ left: 20, right: 20, bottom: 30 })
        }
        .layoutWeight(1)
        .backgroundColor('rgba(255, 255, 255, 0.05)')
        .backdropBlur(10)
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
        .fontSize(18)
        .fontColor('#1A1A1A')
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .borderRadius(18)
        .onClick(() => {
          router.back()
        })

      Text('考勤日志')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontColor('#1A1A1A')

      Button('历史')
        .width(50)
        .height(36)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .borderRadius(18)
        .onClick(() => {
          // 历史记录页面
        })
    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 10 })
  }

  @Builder
  buildTimeSection() {
    Column() {
      Text('当前时间')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 8 })

      Text(this.currentTime)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ bottom: 12 })

      Row() {
        Text('状态：')
          .fontSize(14)
          .fontColor('#666666')

        Text(this.clockStatus)
          .fontSize(14)
          .fontColor(this.clockStatus === '已打卡' ? '#00C853' : '#FF9800')
          .fontWeight(FontWeight.Medium)
      }
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
    .margin({ top: 20, bottom: 25 })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildClockInSection() {
    Column() {
      // 打卡图片和按钮
      Column() {
        Web({
          src: "http://192.168.31.181:5000",
          controller: this.webController
        })
          .width('90%')
          .height('100%')
          .width(200)
          .height(200)
          .border({
            width: 4,
            color: this.isClockingIn ? '#007AFF' : 'rgba(0, 0, 0, 0.1)'
          })
          .margin({ bottom: 20 })

        Button(this.isClockingIn ? '打卡中...' : '📍 立即打卡')
          .width(140)
          .height(50)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.isClockingIn ? '#CCCCCC' : '#007AFF')
          .fontColor(Color.White)
          .borderRadius(25)
          .enabled(!this.isClockingIn)
          .onClick(() => {
            this.handleClockIn()
          })

        if (this.isClockingIn) {
          Row() {
            LoadingProgress()
              .width(20)
              .height(20)
              .color('#007AFF')
              .margin({ right: 8 })

            Text('正在定位打卡...')
              .fontSize(12)
              .fontColor('#666666')
          }
          .justifyContent(FlexAlign.Center)
          .margin({ top: 12 })
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 打卡提示
      Text('请确保在公司范围内进行打卡')
        .fontSize(12)
        .fontColor('#999999')
        .margin({ top: 16 })
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding(25)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ bottom: 25 })
  }

  @Builder
  buildAttendanceStats() {
    Column() {
      Text('今日统计')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })

      Row() {
        this.buildStatItem('上班打卡', '09:00', '')
        this.buildStatItem('下班打卡', '18:30', '')
        this.buildStatItem('工作时长', this.todayWorkTime, '')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
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
    .margin({ bottom: 25 })
  }

  @Builder
  buildStatItem(title: string, value: string, icon: string) {
    Column() {
      Text(icon)
        .fontSize(20)
        .margin({ bottom: 8 })

      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ bottom: 4 })

      Text(title)
        .fontSize(10)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
    }
    .width(90)
    .height(80)
    .padding(8)
    .backgroundColor('rgba(255, 255, 255, 0.6)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.05)'
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildAttendanceRecords() {
    Column() {
      Text('考勤记录')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })

      List() {
        ForEach(['打卡时间: 09:00:00', '离开时间: 18:30:00', '本次工作时间: 07:30:00', '本周已工作时间: 40小时30分钟'], (item: string, index: number) => {
          ListItem() {
            Row() {
              Text(`${index + 1}`)
                .fontSize(14)
                .fontColor('#666666')
                .width(30)

              Text(item)
                .fontSize(14)
                .fontColor('#1A1A1A')
                .layoutWeight(1)

              if (index < 2) {
                Text('✅')
                  .fontSize(16)
                  .fontColor('#00C853')
              } else {
                Text('📈')
                  .fontSize(16)
                  .fontColor('#007AFF')
              }
            }
            .width('100%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .backgroundColor('rgba(255, 255, 255, 0.6)')
            .borderRadius(12)
            .border({
              width: 1,
              color: 'rgba(0, 0, 0, 0.05)'
            })
            .margin({ bottom: 8 })
          }
        })
      }
      .scrollBar(BarState.Off)
      .height(220)
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
  }

  private handleClockIn() {
    this.isClockingIn = true

    // 模拟打卡过程
    setTimeout(() => {
      this.getHttpData('')
      this.clockStatus = '已打卡'
      this.isClockingIn = false

      // 可以在这里添加成功提示
    }, 2000)
  }

  request_url: string = "https://cda3427daadd4eff9af5db916f8f1688.apig.cn-north-4.huaweicloudapis.com/API_daka"

  getHttpData(type: string) {
    let request_url = this.request_url
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        },
        readTimeout: 60000,
        connectTimeout: 60000
      }, (err, data) => {
        if (!err) {
          console.info('Result:' + data.result);
          this.obj = JSON.parse(data.result.toString());

          for (let i = 0; i < this.obj.data.length && i < this.message.length; ++i) {
            this.message[i] = this.obj.data[i].title.toString()
          }
        } else {
          console.info('error:' + JSON.stringify(err));
          this.message = ['打卡失败', '网络连接错误', '请重试', '联系管理员']
        }
      });
  }
}