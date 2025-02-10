//
//  ViewController.swift
//  KisilerUygulamasi
//
//  Created by enecik on 5.10.2024.
//

import UIKit

class Anasayfa: UIViewController {

    @IBOutlet weak var searcBar: UISearchBar!
    @IBOutlet weak var kisilerTableView: UITableView!
    var kisilerListesi = [Kisiler]()
    
    var viewModel = AnasayfaViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searcBar.delegate = self
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        
        _ = viewModel.kisilerListesi.subscribe(onNext: {liste in
            self.kisilerListesi = liste
            DispatchQueue.main.async{
                self.kisilerTableView.reloadData()
            }
            
           })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.kisileriYukle()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let kisi = sender as? Kisiler {
                let gidilecekVC = segue.destination as! KisiDetay
                gidilecekVC.kisi = kisi
                
            }
        }
    }
    
    
  
    
}

extension Anasayfa : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.kisileriYukle()
        }else{
            viewModel.ara(aramaKelimesi: searchText)
        }
    
    }
}


extension Anasayfa : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Bölüm içerisnde ki satır sayısı
        return kisilerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kisi = kisilerListesi[indexPath.row]
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "kisilerHucre") as! // Downcasting
            KisilerHucre
        
        hucre.labelKisiAd.text = kisi.kisi_ad
        hucre.labelKisiTel.text = kisi.kisi_tel
        
        return hucre
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // didselectle hangi satırı seçtiğimizi algılayabiliyoruz.
        // print("\(indexPath.row) seçildi") İlk bunu denedik sonrasında alttaki iki satırı yazdık
        let kisi = kisilerListesi[indexPath.row]
       //  print("\(kisi.kisi_ad!) seçildi") ikinci olarak bu denendi sonrasında altaki satır yazıldı
        
        performSegue(withIdentifier: "toDetay", sender: kisi) // Kişilere tıkladığımızda detayı açmayı sağlıyor
        tableView.deselectRow(at: indexPath, animated: true) // seçim yaptıktan sonta kaldırmayı sağlıyor(gölgeyi)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt // sağdan kaydırma trailing
         indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "sil") {ContextualAction,view,bool in
            let kisi = self.kisilerListesi[indexPath.row]
            
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(kisi.kisi_ad!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive) {action in
                self.viewModel.sil(kisi_id: kisi.kisi_id!)
                
            }
            
            alert.addAction(evetAction)
            self.present(alert, animated: true)
        } // kırmızı olması için .destructive diyoruz
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }
}
