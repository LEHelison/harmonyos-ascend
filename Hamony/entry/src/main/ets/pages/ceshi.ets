import router from '@ohos.router';
import http from '@ohos.net.http';

interface MyObject {
  success: boolean;
  name: string;
  subtitle:string;
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
    this.mobil_url= mobil_url;
    this.index =index;
  }
}
@Entry
@Component
export default struct ceshi{


  //@State message: string = ''
  //@State message :string[] = []
  @State message: string[] = ['打卡时间:', '离开时间:', '本次加班时间:','本周已经工作时间:'];
  obj = {
    success: false,
    name :"hello"
  } as MyObject;
  @State articleList: Array<Article> = []
  build() {
    Column(){
      Row(){
        Image($r('app.media.fanhui'))
          .width(25)
          .margin({left:10})
          .onClick(()=>{
            router.back()
          })
        Text('考勤日志')
          .fontSize(30)
          .margin({right:120})
      }.width('100%').justifyContent(FlexAlign.SpaceBetween).margin(5)

      Column() {
        Image($r('app.media.ditukaoqin'))
          .width(200)
          .height(200)
        Button('打卡')
          .width(100)
          .onClick(() => {
            console.log('')
            this.getHttpData('')
          })
      }
      .width('100%')

      Row() {
        List() {

          ForEach(this.message, (item: string) => {
            ListItem() {
              Text(item).fontSize(22)
            }
            .width("90%")
            .height(100)
            .backgroundColor(Color.White)
            .border({ color: Color.Black, radius: 10, width: 3 })
            .margin(5)
          })
        }
        .padding(10)
        // .scrollBar(BarState.Off)

      }
    }
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'700'})
  }
  request_url:string="https://cda3427daadd4eff9af5db916f8f1688.apig.cn-north-4.huaweicloudapis.com/API_daka"
  getHttpData(type:string) {
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
          console.info('code:' + data.responseCode);
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + data.cookies); // 8+
          this.message[0] = JSON.stringify(data.result)
          this.message[0] = JSON.stringify(data.result)
          this.obj = JSON.parse(data.result.toString());


          console.info('cookies:' +this.obj.name.toString());
          console.info('cookies:' +this.obj.subtitle.toString());
          console.info('cookies:' +this.obj.data.toString());
          console.info('cookies:' +this.obj.data[0].title.toString());


          for (let i = 0; i < this.obj.data.length && i<this.message.length; ++i) {
            console.info(this.obj.data[i].title.toString());
            console.info(this.obj.data[i].hot.toString());
            console.info(this.obj.data[i].url.toString());
            this.message[i] = this.obj.data[i].title.toString()
          }


        } else {
          console.info('error:' + JSON.stringify(err));
        }
      });

  }
}
