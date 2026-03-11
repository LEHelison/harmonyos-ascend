import router from '@ohos.router'
@Entry
@Component
struct ZheXianTuPage2 {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(() => {

          //厂区二
          this.context.font = '80px'
          this.context.fillText("厂区二",140,25)
          //坐标轴
          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(10, 350)
          this.context.lineTo(350, 350)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(10, 60)
          this.context.lineTo(10, 350)
          this.context.stroke()
          this.context.font = '70px'
          this.context.fillText("温度",20,60)
          this.context.font = '70px'
          this.context.fillText("时间",300,380)

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(10, 700)
          this.context.lineTo(350, 700)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(10, 400)
          this.context.lineTo(10, 700)
          this.context.stroke()
          this.context.font = '70px'
          this.context.fillText("湿度",20,400)
          this.context.font = '70px'
          this.context.fillText("时间",300,730)

          //温度折线
          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(20, 180)
          this.context.lineTo(100, 190)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(100, 190)
          this.context.lineTo(180, 185)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(180, 185)
          this.context.lineTo(260, 170)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(260, 170)
          this.context.lineTo(340, 200)
          this.context.stroke()

          //湿度折线
          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(20, 570)
          this.context.lineTo(100, 560)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(100, 560)
          this.context.lineTo(180, 540)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(180, 540)
          this.context.lineTo(260, 530)
          this.context.stroke()

          this.context.lineWidth = 2 //设置绘制线条的宽度
          this.context.beginPath()
          this.context.lineCap = 'round' //指定线端点的样式
          this.context.moveTo(260, 530)
          this.context.lineTo(340, 550)
          this.context.stroke()
        })
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      router.back()
    })
  }

}
