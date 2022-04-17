//
//  Post.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/17/21.
//

import Foundation


struct Post {
    let title: String
    let author: String
    let description: String
    let image: String
    let likes: Int
    let views: Int
    
}

class Posts{
    
  private  var posts: [Post] = [Post]()
    
    func fetchPosts(_ hangler: @escaping (Result<[Post], PostError>)->Void ){
        DispatchQueue.global(qos: .default).async {
            guard let posts = self.createMockData() else {
                hangler(.failure(PostError.ErrorEmptyDate))
                return
            }
            hangler(.success(posts))
        }
    }
    
     func createMockData()-> [Post]?{
          var posts = [Post]()
         
       posts.append(Post(title: "Зарядка устройств по воздуху", author: "3DNews", description: "Ресурс Nikkei сообщает о том, что японская телекоммуникационная компания SoftBank в скором времени приступит к тестированию технологии, которая позволит использовать сотовые вышки в качестве станций беспроводной зарядки для носимых гаджетов", image: "news1", likes: 10, views: 22))
       posts.append(Post(title: "Физики обнаружили новый тип сверхпроводимости и ранее неизвестное состояние вещества", author: "3DNews", description: "Международная группа физиков из Германии и Швейцарии экспериментально обнаружила и подтвердила существование неизвестного ранее состояния вещества, сопутствующего эффекту сверхпроводимости. Явление оказалось настолько уникальным, что предсказать последствия открытия сегодня очень сложно, хотя оно вселяет большие надежды на прорыв в области сверхпроводимости и квантовых приборов. Это первый практический шаг в новую область знаний.", image: "news2", likes: 23, views: 120))
        posts.append(Post(title: "Внезапные наводнения: как появились речные долины на Марсе", author: "Hi-Tech", description: "Согласно новому исследованию, проведенному американскими учеными из Техасского университета в Остине и их коллегами из других институтов, в формировании поверхности Марса большую роль играли внезапные мощные наводнения из переполненных кратерных озер", image: "news3", likes: 15, views: 16))
        posts.append(Post(title: "Из полиэтиленовых пакетов научились готовить дизельное топливо", author: "Ferra", description: "Исследователи изобрели новый метод, который позволяет переработать пластиковые пакеты в дизельное топливо. В основу методики лёг каталитический пиролиз — термохимическое разложение вещества на основе углерода.", image: "news4", likes: 30, views: 56))

          return posts
      }
      
    
}

