import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';

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
export default struct shouye {
  @State message: string[] = ['系统运行状态正常', '设备监控数据更新', '生产效率达标'];
  @State currentTime: string = '';
  @State isDataExpanded: boolean = false;
  @State userName: string = '管理员';

  obj = {
    success: false,
    name: "hello"
  } as MyObject;
  @State articleList: Array<Article> = []

  aboutToAppear(): void {
    this.getHttpData('')
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
      Scroll() {
        Column() {
          // 顶部状态栏
          this.buildHeaderSection()

          // 搜索区域
          this.buildSearchSection()

          // 系统概览
          this.buildSystemOverview()

          // 功能模块区域
          this.buildFunctionModules()

          // 数据监控区域
          this.buildDataMonitoring()
        }
        .padding({ left: 16, right: 16, bottom: 30 })
      }
      .backgroundColor('rgba(240, 248, 255, 0.85)')
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  buildHeaderSection() {
    Column() {
      Row() {
        Column() {
          Text('智慧工厂管理平台')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ bottom: 4 })

          Text(`欢迎，${this.userName}`)
            .fontSize(14)
            .fontColor('#2E3A59')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Column() {
          Text(this.currentTime)
            .fontSize(12)
            .fontColor('#2E3A59')
            .margin({ bottom: 4 })

          Row() {
            Circle({ width: 8, height: 8 })
              .fill('#4A90E2')
              .margin({ right: 6 })

            Text('系统正常')
              .fontSize(12)
              .fontColor('#4A90E2')
              .fontWeight(FontWeight.Medium)
          }
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.9)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(74, 144, 226, 0.2)'
    })
    .margin({ top: 20, bottom: 20 })
  }

  @Builder
  buildSearchSection() {
    Row() {
      Search({ placeholder: '搜索功能模块或设备...' })
        .layoutWeight(1)
        .height(44)
        .backgroundColor('rgba(255, 255, 255, 0.9)')
        .borderRadius(22)
        .border({
          width: 1,
          color: 'rgba(74, 144, 226, 0.3)'
        })
        .placeholderColor('#7A8A9A')
        .fontColor('#1A1A1A')

      Badge({ count: 3, position: BadgePosition.RightTop, style: {
        badgeSize: 16,
        badgeColor: '#4A90E2',
        fontSize: 10
      }}) {
        Button() {
          Text('消息')
            .fontSize(12)
            .fontColor('#4A90E2')
        }
        .width(44)
        .height(44)
        .backgroundColor('rgba(255, 255, 255, 0.9)')
        .borderRadius(22)
        .border({
          width: 1,
          color: 'rgba(74, 144, 226, 0.3)'
        })
        .onClick(() => {
          router.pushUrl({ url: 'pages/youxiang' })
        })
      }
      .margin({ left: 12 })
    }
    .width('100%')
    .margin({ bottom: 24 })
  }

  @Builder
  buildSystemOverview() {

  }

  @Builder
  buildOverviewCard(title: string, value: string, unit: string, color: string) {
    Column() {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .margin({ bottom: 4 })

      Text(title)
        .fontSize(12)
        .fontColor('#1A1A1A')
        .margin({ bottom: 2 })

      Text(unit)
        .fontSize(10)
        .fontColor('#7A8A9A')
    }
    .width(75)
    .height(80)
    .padding(12)
    .backgroundColor('rgba(255, 255, 255, 0.7)')
    .borderRadius(8)
    .border({
      width: 1,
      color: 'rgba(74, 144, 226, 0.15)'
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildFunctionModules() {
    Column() {
      Text('功能模块')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 20 })

      // 第一行：产线监控 + 环境监测
      Row() {
        this.buildModuleCard(
          '产线监控',
          'Production Monitor',
          'PROD',
          '#4A90E2',
          $r('app.media.changxian'),
          () => router.pushUrl({ url: 'pages/MonitorList' })
        )

        this.buildModuleCard(
          '环境监测',
          'Environment Monitor',
          'ENV',
          '#5CB3CC',
          $r('app.media.huanjing'),
          () => router.pushUrl({ url: 'pages/ChangQu' })
        )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 16 })

      // 第二行：告警列表 + 远程控制
      Row() {
        this.buildModuleCard(
          '告警列示',
          'Alert Management',
          'ALERT',
          '#F4A261',
          $r('app.media.gaojing'),
          () => router.pushUrl({ url: 'pages/baojing' })
        )

        this.buildModuleCard(
          '远程操控',
          'Remote Control',
          'CTRL',
          '#E76F51',
          $r('app.media.yuancheng'),
          () => router.pushUrl({ url: 'pages/kongzhi' })
        )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 16 })

      // 第三行：码垛控制 + 巡检功能
      Row() {
        this.buildModuleCard(
          '码垛控制',
          'Robotic Arm Control',
          'ARM',
          '#7DD3C0',
          $r('app.media.maduo'),
          () => router.pushUrl({ url: 'pages/HostListPage' })
        )

        this.buildModuleCard(
          '智能巡检',
          'Smart Inspection',
          'INSP',
          '#A8DADC',
          $r('app.media.xunjian'),
          () => router.pushUrl({ url: 'pages/jiqigou' })
        )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.9)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(74, 144, 226, 0.2)'
    })
    .margin({ bottom: 24 })
  }

  @Builder
  buildModuleCard(title: string, subtitle: string, code: string, accentColor: string, iconResource: Resource, action: () => void) {
    Column() {
      // 图标和模块代码行
      Row() {
        Image(iconResource)
          .width(34)
          .height(34)
          .fillColor(accentColor)
          .margin({left:30})

      }
      .width('100%')
      .margin({ bottom: 12 })

      // 主标题
      Text(title)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 6,left:20 })
      // 装饰性线条
      Row()
        .width('100%')
        .height(3)
        .backgroundColor(accentColor)
        .borderRadius(2)
        .margin({ top: 8 })
    }
    .width('48%')
    .height(100)
    .padding(16)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(74, 144, 226, 0.15)'
    })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(action)
  }

  @Builder
  buildDataMonitoring() {
    Column() {
      Row() {
        Text('数据监控')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')

        Blank()

        Text(this.isDataExpanded ? '收起' : '展开')
          .fontSize(12)
          .fontColor('#4A90E2')
          .onClick(() => {
            this.isDataExpanded = !this.isDataExpanded
          })
      }
      .width('100%')
      .margin({ bottom: this.isDataExpanded ? 16 : 0 })

      if (this.isDataExpanded) {
        Column() {
          ForEach(this.message, (item: string, index: number) => {
            Row() {
              Text(`${(index + 1).toString().padStart(2, '0')}`)
                .fontSize(12)
                .fontColor('#4A90E2')
                .width(30)
                .textAlign(TextAlign.Center)
                .backgroundColor('rgba(74, 144, 226, 0.1)')
                .borderRadius(6)
                .padding({ top: 4, bottom: 4 })

              Text(item)
                .fontSize(14)
                .fontColor('#1A1A1A')
                .layoutWeight(1)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ left: 12, right: 12 })

              Text('正常')
                .fontSize(10)
                .fontColor('#4A90E2')
                .backgroundColor('rgba(74, 144, 226, 0.1)')
                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                .borderRadius(6)
            }
            .width('100%')
            .height(50)
            .padding({ left: 12, right: 12 })
            .backgroundColor('rgba(255, 255, 255, 0.6)')
            .borderRadius(8)
            .border({
              width: 1,
              color: 'rgba(74, 144, 226, 0.1)'
            })
            .margin({ bottom: 8 })
          })

          Button('刷新数据')
            .width('100%')
            .height(40)
            .fontSize(14)
            .backgroundColor('rgba(74, 144, 226, 0.1)')
            .fontColor('#4A90E2')
            .borderRadius(8)
            .border({
              width: 1,
              color: 'rgba(74, 144, 226, 0.3)'
            })
            .margin({ top: 8 })
            .onClick(() => {
              this.getHttpData('')
              promptAction.showToast({
                message: '正在刷新数据...',
                duration: 2000
              })
            })
        }
        .width('100%')
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.9)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(74, 144, 226, 0.2)'
    })
  }

  request_url: string = "https://6511372bec0740fa91189f393ed4c1e9.apig.cn-north-4.huaweicloudapis.com/kaishi"

  getHttpData(type: string) {
    let request_url = this.request_url
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
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
        this.message = ['系统数据加载失败', '请检查网络连接', '稍后重试加载']
      }
    });
  }
}