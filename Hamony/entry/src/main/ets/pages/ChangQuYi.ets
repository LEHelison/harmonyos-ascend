import { McLineChart, Options } from '@mcui/mccharts'

@Entry
@Component
struct Index {
  // 第一个图表的数据（可以与第一个相同或不同）
  @State seriesOption1: Options = new Options({
    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
      name: '数值'
    },
    series: [
      {
        name: '平均温度',
        data: [13, 21, 15, 16, 27, 30, 18]
      },
      {
        name: '平均湿度',
        data: [60, 40, 55, 65, 55, 45, 70]
      },
      {
        name: '平均噪音dB',
        data: [26, 23, 42, 63, 45, 32, 25]
      },
      {
        name: '平均温度℃',
        data: [28, 30, 30, 15, 20, 15, 23]
      }
    ]
  })

  // 动态修改数据
  aboutToAppear() {
    setTimeout(() => {
      // 更新第一个图表的数据
      this.seriesOption1.setVal({
        series: [
          {
            name: '平均PM2.5',
            data: [11, 11, 15, 13, 12, 19, 10]
          },
          {
            name: '平均湿度%',
            data: [38, 20, 30, 25, 40, 35, 45]
          },
          {
            name: '平均噪音dB',
            data: [26, 23, 42, 63, 45, 32, 25]
          },
          {
            name: '平均温度℃',
            data: [28, 30, 30, 15, 20, 15, 23]
          }
        ]
      })


    }, 2000)
  }

  build() {
    Column({space:40}) { // 使用Column布局使两个图表垂直排列
      Text('厂区一')
        .fontSize(20)
        .fontWeight(700)
        .margin(10)
      Column({space:15}){
        Text('实时数据')
          .fontSize(20)
          .fontWeight(500)
          .fontColor('#ff4e81e7')
          .margin({top:10})
        Row(){
          Text('空气湿度：16%')
            .fontSize(20)
          Text('正常')
            .fontSize(20)
        }
        .width('100%')
        .height(45)
        .justifyContent(FlexAlign.SpaceAround)
        Row(){
          Text('PM2.5：150微克')
            .fontSize(20)
          Text('重度')
            .fontSize(20)
        }
        .width('100%')
        .height(45)
        .justifyContent(FlexAlign.SpaceAround)
        Row(){
          Text('噪音：85')
            .fontSize(20)
          Text('良好')
            .fontSize(20)
        }
        .width('100%')
        .height(45)
        .justifyContent(FlexAlign.SpaceAround)
        Row(){
          Text('温度：25')
            .fontSize(20)
          Text('良好')
            .fontSize(20)
        }
        .width('100%')
        .height(45)
        .justifyContent(FlexAlign.SpaceAround)
      }
      .backgroundColor('#ffc1ceee')
      .borderRadius(20)
      .width('90%')
      .height(220)
      .justifyContent(FlexAlign.SpaceAround)
      Column(){
        Row() {
          McLineChart({
            options: this.seriesOption1
          })
        }
        .height('50%')
        Text('历史数据')
          .fontSize(20)
          .fontWeight(500)
          .fontColor('#ff4e81e7')
      }

    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.img'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}