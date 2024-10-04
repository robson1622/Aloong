//
//  ActivityImageController.swift
//  Macro
//
//  Created by Robson Borges on 15/09/24.
//

import Foundation


class ActivityImageController: ObservableObject{
    static var shared : ActivityImageController = ActivityImageController()
    @Published var listOfActivityImages : [ActivityImageModel] = []
    private let activityIdFieldName : String = "idActivity"
    
    func readAllActivityImagesOfActivity(idActivity : String?,reload : Bool = false) async -> [ActivityImageModel]{
        print("FALTA FAZER SALVAR OS DOCUMENTOS LOCALMENTE NA VARIÁVEL shared - ActivityImageController/readAllActivityImagesOfActivity")
        if idActivity != nil{
            if(self.listOfActivityImages.isEmpty){
                return await DatabaseInterface.shared.readDocuments(isEqualValue: idActivity!, table: .activityImage, field: activityIdFieldName)
            }
            let retorno = self.listOfActivityImages.filter { actimage in
                let response = actimage.idActivity?.range(of: idActivity!, options: .caseInsensitive) != nil
                return response
            }
            for image in retorno{
                if let url = image.imageURL{
                    BucketOfImages.shared.download(from: url){ _ in }
                }
            }
            
            return retorno
        } else { return [] }
    }
    
    func readAllActivityImagesOfGroup(idGroup : String?,reload : Bool = false) async -> [ActivityImageModel]{
        print("FALTA FAZER SALVAR OS DOCUMENTOS LOCALMENTE NA VARIÁVEL shared - ActivityImageController/readAllActivityImagesOfGroup")
        if idGroup == nil{ return [] }
        if(reload || !listOfActivityImages.isEmpty){
            listOfActivityImages.removeAll()
            let listOfActivities : [ActivityModel] = await ActivitiesController.shared.readActivitiesOfGroup(idGroup: idGroup!)
            for activity in listOfActivities{
                let activityImages : [ActivityImageModel] = await self.readAllActivityImagesOfActivity(idActivity: activity.id!)
                for activityImage in activityImages{
                    self.listOfActivityImages.append(activityImage)
                }
            }
        }
        return self.listOfActivityImages
    }
    
}
