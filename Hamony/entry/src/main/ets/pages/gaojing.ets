import router from '@ohos.router'

class Item{
  name1:string
  name2:string
  name3:string

  constructor(name1:string,name2:string,name3:string) {
    this.name1=name1
    this.name2=name2
    this.name3=name3
  }
}

@Entry
@Component
struct gaojing {

  private item:Array<Item> = [
    new Item('温度超出42.1摄氏度','重度',' 厂区二'),
    new Item('温度超出42.1摄氏度','重度',' 厂区一'),
    new Item('空气湿度超过15%','重度',' 厂区三'),
    new Item('温度超出42.1摄氏度','重度',' 厂区一'),
    new Item('空气湿度超过15%','重度',' 厂区三'),
    new Item('温度超出42.1摄氏度','重度',' 厂区二'),
    new Item('温度超出42.1摄氏度','重度',' 厂区三'),
    new Item('空气湿度超过15%','重度',' 厂区一'),
    new Item('温度超出42.1摄氏度','重度',' 厂区二'),
    new Item('空气湿度超过15%','重度',' 厂区一'),
    new Item('温度超出42.1摄氏度','重度',' 厂区三'),
    new Item('温度超出42.1摄氏度','重度',' 厂区二'),
    new Item('空气湿度超过15%','重度',' 厂区一'),
    new Item('温度超出42.1摄氏度','重度',' 厂区三'),
    new Item('空气湿度超过15%','重度',' 厂区一'),
  ]

  build(){
    Column(){
      //机房报警管理
      Row(){
        Image($r('app.media.a'))
          .width(35)
          .onClick(()=>{
            router.back()
          })
        Text('机房报警管理')
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({left:60})
        Image($r('app.media.k'))
          .width(40)
          .margin({left:60})
      }
      .width('100%')
      .height(50)
      //图片
      Row(){
        Image($r('app.media.l'))
          .width('100%')
          .height(150)
      }
      //故障
      Column(){
        List({space:8}){
          ForEach(
            this.item,
            (item:Item)=> {
              ListItem(){
                Row(){
                  Text(item.name1)
                    .width('45%')
                    .fontSize(15)
                    .margin({left:10})
                    .fontColor('red')
                  Text(item.name2)
                    .width('15%')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                  Text(item.name3)
                    .width('40%')
                    .fontSize(15)
                    .margin({left:50})
                }
                .width('98%')
                .height(40)
                .borderColor('#e6e6e6')
                .borderWidth({bottom:1})
              }
            }
          )
        }
        .width('98%')
        .layoutWeight(0)
      }
      .width('100%')
      .height('260')
      Row(){
        Text('…')
          .fontSize(30)
          .textAlign(TextAlign.Center)
      }
      .height(30)
      Column(){
        Text('前往处理')
          .fontSize(30)
          .fontColor('#8a8a8a')
        Image($r('app.media.m'))
          .width(60)
          .margin({top:20})
      }
      .width('100%')
      .margin({top:100})
      .onClick(()=>{
        router.push({url:'pages/yuancheng'})//厂区
      })
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'700'})
  }
}
