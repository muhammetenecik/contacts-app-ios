//
//  AnasayfaViewModel.swift
//  KisilerUygulamasi
//
//  Created by enecik on 9.10.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    
    var krepo = KisilerDaoRepository()
    var kisilerListesi = BehaviorSubject<[Kisiler]>(value: [Kisiler]())
    
    init(){
        kisilerListesi = krepo.kisilerListesi
        kisileriYukle()
        
    }
    
    
    func sil (kisi_id:String){
        krepo.sil(kisi_id: kisi_id)
        
    }
    
    
    func ara(aramaKelimesi:String){
        krepo.ara(aramaKelimesi: aramaKelimesi)
        
    }
    
    func kisileriYukle(){
      krepo.kisileriYukle()
    }
}
