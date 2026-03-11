// import http from '@ohos.net.http';
// import { ResponseResult } from '../model/ResponseResult';
//
// export function httpRequestGet(url: string): Promise<ResponseResult>{
//   let httpRequest = http.createHttp()
//   let httpResponse = httpRequest.request(url,{
//     method:http.RequestMethod.GET,
//     readTimeout: 10000,
//     connectTimeout: 10000
//   })
//
//   let httpResult = new ResponseResult()
//
//   return httpRequest.then((value)=>{
//     if (value.responseCode === 200) {
//       let jsonResult: ResponseResult = JSON.parse('${value.result}')
//       if (jsonResult.flag) {
//         httpResult.data = jsonResult.data
//         httpResult.flag = true
//         httpResult.message = 'http request success'
//       }else {
//         httpResult.message = 'http request fail'
//       }
//     }else {
//     httpResult.message = 'http reqiest fail' + value.responseCode
//     }
//     return httpResult
//   }).catch((error)=>{
//     httpResult.messagr = 'http request error'
//     return httpRequest
//   })
// }
//
// export function httpRequestPost(url: string): Promise<ResponseResult>{
//   let httpRequest = http.createHttp()
//   let httpResponse = httpRequest.request(url,{
//     method:http.RequestMethod.POST,
//     extraData: params,
//     readTimeout: 10000,
//     connectTimeout: 10000
//   })
//
//   let httpResult = new ResponseResult()
//
//   return httpRequest.then((value)=>{
//     if (value.responseCode === 200) {
//       let jsonResult: ResponseResult = JSON.parse('${value.result}')
//       if (jsonResult.flag) {
//         httpResult.data = jsonResult.data
//         httpResult.flag = true
//         httpResult.message = 'http request success'
//       }else {
//         httpResult.message = 'http request fail'
//       }
//     }else {
//       httpResult.message = 'http reqiest fail' + value.responseCode
//     }
//     return httpResult
//   }).catch((error)=>{
//     httpResult.messagr = 'http request error'
//     return httpRequest
//   })
// }