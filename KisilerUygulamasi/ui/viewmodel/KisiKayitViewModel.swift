//
//  KisiKayitViewModel.swift
//  KisilerUygulamasi
//
//  Created by enecik on 9.10.2024.
//

import Foundation

class KisiKayitViewModel {
    var krepo = KisilerDaoRepository() // Repoya erişeceğimizi belirtiyoruz
    func kaydet(kisi_ad:String,kisi_tel:String){
        krepo.kaydet(kisi_ad: kisi_ad, kisi_tel: kisi_tel)
    }
    
}
