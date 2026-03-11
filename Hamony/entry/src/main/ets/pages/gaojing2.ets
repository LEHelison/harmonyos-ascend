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
struct gaojing2 {

  private item:Array<Item> = [
    new Item('(1)温度超出42.1摄氏度',' 厂区二','2024-7 13：22'),
    new Item('(2)湿度低于15%',' 厂区三','2024-7 15：22'),
    new Item('(3)温度超出42.1摄氏度',' 厂区一','2024-7 01：22'),
    new Item('(4)湿度低于15%',' 厂区三','2024-7 13：22'),
    new Item('(5)温度超出42.1摄氏度',' 厂区二','2024-7 13：22'),
    new Item('(6)温度超出42.1摄氏度',' 厂区三','2024-7 13：22'),
    new Item('(7)湿度低于15%',' 厂区一','2024-7 13：22'),
    new Item('(8)温度超出42.1摄氏度',' 厂区二','2024-7 13：22'),
    new Item('(9)温度超出42.1摄氏度',' 厂区一','2024-7 13：22'),
    new Item('(10)湿度低于15%',' 厂区三','2024-7 13：22'),
    new Item('(11)温度超出43摄氏度',' 厂区一','2024-7 10：22'),
    new Item('(12)湿度低于15%',' 厂区二','2024-7 13：22'),
    new Item('(13)温度超出42摄氏度',' 厂区一','2024-7 13：22'),
    new Item('(14)温度超出42摄氏度',' 厂区三','2024-7 13：22'),
    new Item('(15)湿度低于15%',' 厂区一','2024-7 13：22'),
    new Item('(16)温度超出43摄氏度',' 厂区二','2024-7 10：22'),
    new Item('(17)湿度低于15%',' 厂区一','2024-7 13：22'),
    new Item('(18)湿度低于15%',' 厂区三','2024-7 13：22'),
    new Item('(19)温度超出43摄氏度',' 厂区二','2024-7 10：22'),
    new Item('(20)湿度低于15%',' 厂区三','2024-7 13：22'),
    new Item('(21)温度超出42摄氏度',' 厂区一','2024-7 13：22'),
    new Item('(22)温度超出44摄氏度',' 厂区三','2024-7 13：22'),
    new Item('(23)湿度低于15%',' 厂区一','2024-7 13：22'),
    new Item('(24)温度超出43摄氏度',' 厂区二','2024-7 10：22'),
    new Item('(25)湿度低于15%',' 厂区一','2024-7 13：22')
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
        Image($r('app.media.v'))
          .width(35)
          .margin({left:60})
      }
      .width('100%')
      .height(50)
      .backgroundColor('#e6e6e6')
      //图片
      Row(){
        Image($r('app.media.img2'))
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
                  Text(item.name2)
                    .width('15%')
                    .fontSize(15)
                  Text(item.name3)
                    .width('40%')
                    .fontSize(15)
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

    }
    .width('100%')
    .height('100%')
  }
}
