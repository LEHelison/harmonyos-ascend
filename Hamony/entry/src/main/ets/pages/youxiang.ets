import router from '@ohos.router';
import http from '@ohos.net.http';

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
  @State message: string[] = ['请获取信息后查看', '请获取信息后查看', '请获取信息后查看'];
  @State isLoading: boolean = false;

  obj = {
    success: false,
    name: "hello"
  } as MyObject;
  @State articleList: Array<Article> = []

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

          Text('企业邮箱')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor('#1A1A1A')

          Button('刷新')
            .width(60)
            .height(36)
            .fontSize(14)
            .fontColor('#1A1A1A')
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .borderRadius(18)
            .enabled(!this.isLoading)
            .onClick(() => {
              this.getHttpData('')
            })
        }
        .width('100%')
        .height(60)
        .padding({ left: 20, right: 20, top: 10 })

        // 主体内容
        Scroll() {
          Column() {
            // 操作按钮
            Button(this.isLoading ? '获取中...' : '📧 获取收件信息')
              .width('80%')
              .height(50)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .backgroundColor(this.isLoading ? '#CCCCCC' : '#007AFF')
              .fontColor(Color.White)
              .borderRadius(25)
              .enabled(!this.isLoading)
              .margin({ top: 20, bottom: 30 })
              .onClick(() => {
                this.getHttpData('')
              })

            if (this.isLoading) {
              Row() {
                LoadingProgress()
                  .width(20)
                  .height(20)
                  .color('#007AFF')
                  .margin({ right: 8 })

                Text('正在获取邮件...')
                  .fontSize(14)
                  .fontColor('#666666')
              }
              .justifyContent(FlexAlign.Center)
              .margin({ bottom: 20 })
            }

            // 邮件列表
            List() {
              ForEach(this.message, (item: string, index: number) => {
                ListItem() {
                  Row() {
                    Text('📧')
                      .fontSize(20)
                      .margin({ right: 12 })

                    Text(item)
                      .fontSize(14)
                      .fontColor('#1A1A1A')
                      .layoutWeight(1)
                      .maxLines(10)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .width('100%')
                  .height(180)
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
              })
            }
            .scrollBar(BarState.Off)
            .padding({ left: 20, right: 20 })
          }
        }
        .layoutWeight(1)
        .backgroundColor('rgba(255, 255, 255, 0.05)')
        .backdropBlur(10)
      }
    }
    .height('100%')
    .width('100%')
  }

  request_url: string = "https://e905c42ec00f4b6390023c3181df270a.apig.cn-north-4.huaweicloudapis.com/API_youxiang"

  getHttpData(type: string) {
    this.isLoading = true
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
      this.isLoading = false

      if (!err) {
        console.info('Result:' + data.result);
        this.obj = JSON.parse(data.result.toString());

        for (let i = 0; i < this.obj.data.length && i < this.message.length; ++i) {
          this.message[i] = this.obj.data[i].title.toString()
        }
      } else {
        console.info('error:' + JSON.stringify(err));
        this.message = ['网络连接失败', '请检查网络设置', '稍后重试']
      }
    });
  }
}