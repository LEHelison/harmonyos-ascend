import { LengthMetrics, router, window } from '@kit.ArkUI'
import { http } from '@kit.NetworkKit'


@Extend(Text)
function text1(){
  .fontSize(21).fontColor($r('app.color.BackgroundColor'))
}

let thresholdPM: number = 0
let thresholdNoise: number = 0
@Entry
@Component
struct Index {

  @State noisemodule: noiseModule = new noiseModule()
  @State pmmodule: pmModule = new pmModule()
  @State debuglog: debugLog = new debugLog()

  dialogController1: CustomDialogController = new CustomDialogController({
    builder: setting1({
      cancel: ()=> {  },
      confirm: ()=> { this.debugPM() },
    }),

  })
  dialogController2: CustomDialogController = new CustomDialogController({
    builder: setting2({
      cancel: ()=> {  },
      confirm: ()=> { this.debugNoise() },
    }),

  })

  onPageShow(): void {
    window.getLastWindow(getContext(this),(err,win) => {
      win.setWindowLayoutFullScreen(true)
    })
  }

  aboutToAppear(): void {
    this.getNoiseData()
    this.getPmData()
  }


  build() {
    Column({space:20}) {
      Row(){
        Image($r('app.media.fanhui'))
          .width(40)
          .fillColor($r('app.color.MainColor1'))
          .onClick(()=> {
            router.back()
          })
      }
      .padding(10)
      .justifyContent(FlexAlign.Start)
      .width('90%')

      Row(){
        Text('厂区一')
          .fontSize(50)
          .fontColor($r('app.color.MainColor1'))
          .fontWeight(FontWeight.Bolder)

        Image($r('app.media.refresh'))
          .width(50)
          .fillColor($r('app.color.MainColor1'))
          .onClick(() => {
            this.getNoiseData()
            this.getPmData()
          })
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({bottom: 20})


      //卡片
      Flex({wrap: FlexWrap.Wrap,justifyContent: FlexAlign.SpaceBetween,space: { cross:LengthMetrics.vp(20)}}){
        Column({space: 15}){
          Text('温度')
            .fontSize(30)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.BackgroundColor'))
          Row(){
            Text('当前:').text1()
            Text('25℃').text1()
          }
          Row(){
            Text('阈值:').text1()
            Text('30℃').text1()
          }
        }
        .padding(20)
        .width('48%')
        .aspectRatio(1)
        .borderRadius(15)
        .linearGradient(
          {
            direction: GradientDirection.Top, //从下向上。 渐变方向
            colors: [[$r('app.color.MainColor1'),0.2], [$r('app.color.MainColor2'), 0.7]]
          }
        )



        Column({space: 15}){
          Text('湿度')
            .fontSize(30)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.BackgroundColor'))
          Row(){
            Text('当前:').text1()
            Text('10g/m³').text1()
          }
          Row(){
            Text('阈值:').text1()
            Text('13g/m³').text1()
          }
        }
        .padding(20)
        .width('48%')
        .aspectRatio(1)
        .borderRadius(15)
        .linearGradient(
          {
            direction: GradientDirection.Top, //从下向上。 渐变方向
            colors: [[$r('app.color.MainColor1'),0.2], [$r('app.color.MainColor2'), 0.7]]
          }
        )

        Column({space: 15}){
          Text('PM2.5')
            .fontSize(30)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.BackgroundColor'))
          Row(){
            Text('当前:').text1()
            Text(this.pmmodule.PM25Data +'μg/m³').text1()
          }
          Row(){
            Text('阈值:').text1()
            Text(this.pmmodule.Threshold+'μg/m³').text1()
          }
        }
        .padding(20)
        .width('48%')
        .aspectRatio(1)
        .borderRadius(15)
        .linearGradient(
          {
            direction: GradientDirection.Top, //从下向上。 渐变方向
            colors: [[$r('app.color.MainColor1'),0.2], [$r('app.color.MainColor2'), 0.7]]
          }
        )
        .gesture(
          // 绑定可以重复触发的LongPressGesture(长按)
          LongPressGesture()
            .onAction(( ) => {
              this.dialogController1.open()
            })
        )

        Column({space: 15}){
          Text('噪音')
            .fontSize(30)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.BackgroundColor'))
          Row(){
            Text('当前:').text1()
            Text(this.noisemodule.NoiseVolume.toFixed()+'dB').text1()
          }
          Row(){
            Text('阈值:').text1()
            Text(this.noisemodule.Threshold+'dB').text1()
          }
        }
        .padding(20)
        .width('48%')
        .aspectRatio(1)
        .borderRadius(15)
        .linearGradient(
          {
            direction: GradientDirection.Top, //从下向上。 渐变方向
            colors: [[$r('app.color.MainColor1'),0.2], [$r('app.color.MainColor2'), 0.7]]
          }
        )
        .gesture(
          // 绑定可以重复触发的LongPressGesture(长按)
          LongPressGesture()
            .onAction(( ) => {
              this.dialogController2.open()
            })
        )

      }
      .width('90%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F5F7FA')
  }

  getData(){
    this.getNoiseData()
    this.getPmData()
  }

  getNoiseData() {
    let HttpRequest = http.createHttp()
    let url = 'http://192.168.18.129:5000/noise_data'
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          console.info('getData success:' + response.result)
          // 使用类型断言（这里假设响应体的结构是正确的）
          const parsedData = JSON.parse(response.result.toString()) as noiseModule;
          this.noisemodule = parsedData;
          console.info('noisemodule:'+JSON.stringify(this.noisemodule))
          thresholdNoise = this.noisemodule.Threshold
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
          // 可以设置一个错误状态或显示错误信息
        }
      }
    })
  }

  getPmData() {
    let HttpRequest = http.createHttp()
    let url = 'http://192.168.18.129:5000/pm25_data'
    HttpRequest.request(url, {
      method: http.RequestMethod.GET,
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          console.info('getData success:' + response.result)
          // 使用类型断言（这里假设响应体的结构是正确的）
          const parsedData = JSON.parse(response.result.toString()) as pmModule;
          this.pmmodule = parsedData;
          console.info('pmmodule:'+JSON.stringify(this.pmmodule))
          thresholdPM = this.pmmodule.Threshold
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
          // 可以设置一个错误状态或显示错误信息
        }
      }
    })
  }


  debugPM(){
    let HttpRequest = http.createHttp()
    let url = 'http://192.168.18.129:5000/set_pm25_threshold'
    HttpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: { // 添加请求头
        "Content-Type": "application/json",
      },
      extraData: {
        "threshold": thresholdPM
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          console.info('debugPM success:' + response.result)
          // 使用类型断言（这里假设响应体的结构是正确的）
          const parsedData = JSON.parse(response.result.toString()) as debugLog;
          this.debuglog = parsedData;
          console.info('debuglog:'+JSON.stringify(this.pmmodule))
          setTimeout(() => {
            this.getData()
          },3000)
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
          // 可以设置一个错误状态或显示错误信息
        }
      }
    })
  }

  debugNoise(){
    let HttpRequest = http.createHttp()
    let url = 'http://192.168.18.129:5000/set_noise_threshold'
    HttpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: { // 添加请求头
        "Content-Type": "application/json",
      },
      extraData: {
        "threshold": thresholdNoise
      }
    }).then((response) => {
      if (response.responseCode === http.ResponseCode.OK) {
        console.info('网络请求的结果', response.result);
        try {
          console.info('debugNoise success:' + response.result)
          // 使用类型断言（这里假设响应体的结构是正确的）
          const parsedData = JSON.parse(response.result.toString()) as debugLog;
          this.debuglog = parsedData;
          console.info('debuglog:'+JSON.stringify(this.pmmodule))
          setTimeout(() => {
            this.getData()
          },3000)
        } catch (error) {
          console.error('解析 JSON 数据时出错', error);
          // 可以设置一个错误状态或显示错误信息
        }
      }
    })
  }

}


@CustomDialog
struct setting1{
  controller?: CustomDialogController
  cancel = () => {
  }
  confirm = () => {
  }

  build() {
    Column({space:20}){

      Text('设置阈值:')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
      Row({space:10}){
        Text('阈值:')
        TextInput({placeholder:thresholdPM.toString()})
          .onChange((value) => {
            thresholdPM = Number(value)
          })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
            }
            if (this.cancel) {
              this.cancel();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确定')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
            }
            this.confirm();
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
    .width('60%')
    .aspectRatio(1.1)
    .padding(30)
  }
}

@CustomDialog
struct setting2{
  controller?: CustomDialogController
  cancel = () => {
  }
  confirm = () => {
  }

  build() {
    Column({space:20}){

      Text('设置阈值:')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
      Row({space:10}){
        Text('阈值:')
        TextInput({placeholder:thresholdNoise.toString()})
          .onChange((value) => {
            thresholdNoise = Number(value)
          })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
            }
            if (this.cancel) {
              this.cancel();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确定')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
            }
            this.confirm();
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
    .width('60%')
    .aspectRatio(1.1)
    .padding(30)
  }
}


class noiseModule{
  NoiseVolume: number = 0
  Threshold: number = 0
}

class pmModule{
  PM25Data: number = 0
  Threshold: number = 0
}

class debugLog{
  success: boolean = false
}