//
//  ListViewController.swift
//  HelloWorldJdJVL
//
//  Created by José De Jesús Vega López on 21/04/26.
//

// DESCRIPCIÓN: Lista de personajes de Star Wars con tabla, búsqueda y favoritos.
// Tabla via IBOutlet (storyboard). Search y refresh son genéricos UIKit programáticos.
//
// FUNCIONES:
// - configureComponents(): Configura searchController, refreshControl, tabla.
// - refresh(): Pull-to-refresh (actualmente limpia lista para demo).
// - getMovieList(): Llama al ViewModel async, recarga tabla o muestra alerta.
// - showAlert(): Presenta UIAlertController genérico.
// - reloadData(): Recarga tabla y muestra emptyLabel si no hay datos.
//
// EXTENSION UITableViewDelegate/DataSource:
// - didSelectRowAt: Push a CharacterDetailViewController.
// - cellForRowAt: Celda genérica con nombre, URL, icono y botón estrella (favorito).
// - favoriteTapped(): Toggle favorito y recarga celda.
//
// EXTENSION UISearchResultsUpdating:
// - updateSearchResults(): Filtra por nombre (case-insensitive).
//
// NOTAS:
// - isSearching: determina si usar filteredList o pokemonList completo.
// - emptyLabel: UILabel genérico como backgroundView de tabla vacía.

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - PUBLIC PROPERTIES
    
    // Instancia del ViewModel encargada de manejar la lógica y los datos
    let viewModel = ListViewModel()
    
    // MARK: - PRIVATE PROPERTIES
    
    // Control utilizado para realizar la acción de "pull to refresh"
    private let refreshControl = UIRefreshControl()
    
    //Inicio nuevo
    // Controlador del buscador para filtrar personajes
    private let searchController = UISearchController(searchResultsController: nil)
    
    // Lista filtrada que se muestra cuando el usuario está buscando
    private var filteredList: [GetPokemon.Pokemon] = []
    
    // Bandera que indica si actualmente hay una búsqueda activa
    private var isSearching: Bool {
        searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    //Termina nuevo
    
    // MARK: - Ui Components
    
    // Tabla principal donde se mostrará la lista de pokemones
    @IBOutlet weak var listTable: UITableView!
    
    // Label que se muestra cuando no existen datos disponibles
    private let emptyLabel: UILabel = {
        let label = UILabel()
        
        // Permite mostrar el texto en dos líneas
        label.numberOfLines = 2
        
        // Texto mostrado cuando no hay resultados
        label.text = "Oops...\nSorry, we couldn't find any pokemon."
        
        // Centra el texto dentro del label
        label.textAlignment = .center
        
        return label
    }()
        
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura los componentes iniciales de la vista
        configureComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Se ejecuta al aparecer la vista para obtener la lista de pokemones
        getMovieList()
    }
    
    
    private func configureComponents() {
        
        //Inicio nuevo
        // Título mostrado en la parte superior de la pantalla
        navigationItem.title = "Explorar Personajes"
        
        // Configuración del buscador que aparece debajo del título
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar personajes"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        //Termina nuevo
        
        // Texto mostrado al realizar pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        // Se asigna la acción que se ejecutará al refrescar
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        
        // Se agrega el refresh control a la tabla
        listTable.addSubview(refreshControl)
        
        // Se asignan delegate y datasource de la tabla
        listTable.delegate = self
        listTable.dataSource = self
        
        // Registro de la celda reutilizable con identificador "cell"
        listTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    @objc private func refresh(_ sender: AnyObject) {
        // Llamada normal para recargar datos desde API
        //getMovieList()
        
        // Solo para probar visualmente el estado vacío
        viewModel.pokemonList = []
        
        // Se recarga la tabla
        reloadData()
        
        // Finaliza la animación del refresh control
        refreshControl.endRefreshing()
    }
    
    private func getMovieList() {
        Task {
            do {
                // Llama al ViewModel para obtener la lista de pokemones
                try await viewModel.getPokemonList()
                
                // Recarga la tabla con los nuevos datos
                reloadData()
            }
            catch {
                // Muestra una alerta si ocurre algún error
                showAlert(title: "Oops...", message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        
        // Se crea una alerta con título y mensaje
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Botón de confirmación para cerrar la alerta
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        // Se agrega la acción a la alerta
        alert.addAction(alertAction)
        
        // Se presenta la alerta en pantalla
        present(alert, animated: true)
    }
    
    private func reloadData() {
        
        // Recarga visualmente la tabla
        listTable.reloadData()
        
        // Si no hay contenido disponible
        if !viewModel.hasContent {
            
            // Se muestra el label de estado vacío
            listTable.backgroundView = emptyLabel
            
            // Se ocultan las líneas separadoras de las celdas
            listTable.separatorStyle = .none
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Acción que se ejecuta cuando se selecciona una celda
        //Inicio nuevo
        let data = isSearching ? filteredList[indexPath.row] : viewModel.pokemonList[indexPath.row]
        
        // Navega a la pantalla de detalle del personaje seleccionado
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "CharacterDetail") as! CharacterDetailViewController
        detailVC.character = data
        navigationController?.pushViewController(detailVC, animated: true)
        
        // Deselecciona visualmente la fila
        tableView.deselectRow(at: indexPath, animated: true)
        //Termina nuevo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Retorna el número total de elementos de la lista
        //Inicio nuevo
        return isSearching ? filteredList.count : viewModel.pokemonList.count
        //Termina nuevo
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Se obtiene el dato correspondiente según la posición seleccionada
        //Inicio nuevo
        let data = isSearching ? filteredList[indexPath.row] : viewModel.pokemonList[indexPath.row]
        //Termina nuevo
        
        // Se crea o reutiliza una celda con identificador "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Se obtiene la configuración por defecto de la celda
        var content = cell.defaultContentConfiguration()
        
        // Se configura el contenido principal de la celda
        content.text = data.name
        
        // Texto secundario mostrado debajo del principal
        content.secondaryText = data.url
        
        // Imagen del sistema asignada a la celda
        content.image = UIImage(systemName: "cat.fill")
        
        // Se asigna la configuración final a la celda
        cell.contentConfiguration = content
        
        //Inicio nuevo
        // Botón de favorito mostrado al costado derecho de la celda
        let favoriteButton = UIButton(type: .system)
        let iconName = FavoritesViewController.isFavorite(data) ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.tag = indexPath.row
        favoriteButton.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)
        cell.accessoryView = favoriteButton
        //Termina nuevo
        
        return cell
    }
    
    //Inicio nuevo
    @objc private func favoriteTapped(_ sender: UIButton) {
        
        // Se obtiene el personaje correspondiente al botón presionado
        let item = isSearching ? filteredList[sender.tag] : viewModel.pokemonList[sender.tag]
        
        // Se agrega o elimina de la lista de favoritos
        FavoritesViewController.toggle(item)
        
        // Se recarga la celda para actualizar el ícono
        listTable.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
    //Termina nuevo
    
}

//Inicio nuevo
// MARK: - UISearchResultsUpdating

extension ListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Texto ingresado en el buscador
        let text = (searchController.searchBar.text ?? "").lowercased()
        
        // Filtra los personajes cuyo nombre contiene el texto buscado
        filteredList = viewModel.pokemonList.filter {
            ($0.name ?? "").lowercased().contains(text)
        }
        
        // Recarga la tabla para mostrar el resultado del filtrado
        listTable.reloadData()
    }
}
//Termina nuevo
