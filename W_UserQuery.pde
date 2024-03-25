class UserQueryUI extends Widget {

  private Consumer<FlightType[]> m_onLoadDataEvent;

  QueryManagerClass m_queryManager;
  private ArrayList<String> m_queries; // All query types are ordered like so (Day, Airline, FlightNum, Origin, Dest, SchDep, Dep, Depdelay, SchArr, Arr, ArrDelay, Cancelled, Dievrted, Miles  )
  private ArrayList<FlightQueryType> m_flightQueries;
  private ListboxUI m_queryList;
  private TextboxUI m_day;
  private ButtonUI  clearListButton;
  private ButtonUI  removeSelectedButton;
  private ButtonUI  addItemButton;
  private ButtonUI  loadDataButton;
  private QueryLocationType m_location;
  public int m_listCounter;
  private FlightQueryType m_dayQuery;
  private FlightType[] m_flights;
  private FlightMap3D m_flightMap3D;


  private FlightMultiDataType m_flightsLists;


  private Screen m_screen;


  UserQueryUI(int posX, int posY, int scaleX, int scaleY, QueryManagerClass queryManager, Screen screen) {
    super(posX, posY, scaleX, scaleY);

    m_screen = screen;
    m_queryManager = queryManager;

    m_queryList = new ListboxUI<String>(20, 650, 200, 400, 40, v -> v);
    m_queries = new ArrayList<String>();

    m_flightQueries = new ArrayList<FlightQueryType>();

    addWidget(m_queryList);
    

    addItemButton = new ButtonUI(20, 600, 80, 20);
    addWidget(addItemButton);
    addItemButton.setText("Add item");
    addItemButton.getOnClickEvent().addHandler(e -> saveQuery(m_day));


    clearListButton = new ButtonUI(120, 600, 80, 20);
    addWidget(clearListButton);
    clearListButton.setText("Clear");
    clearListButton.getOnClickEvent().addHandler(e -> clearQueries());

    removeSelectedButton = new ButtonUI(220, 600, 80, 20);
    addWidget(removeSelectedButton);
    removeSelectedButton.setText("Remove selected");
    removeSelectedButton.getOnClickEvent().addHandler(e -> m_queryList.removeSelected());
    
    loadDataButton = new ButtonUI(220, 500, 180, 120);
    addWidget(loadDataButton);
    loadDataButton.setText("Load Data");
    loadDataButton.getOnClickEvent().addHandler(e -> loadData());

    m_day =  new TextboxUI(20, 500, 160, 30);
    addWidget(m_day);
    m_day.setPlaceholderText("Kilometers (Greater than)");


    

    m_dayQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, QueryLocationType.US, queryManager);


    m_flightQueries.add(m_dayQuery);
    //   m_flights = convertBinaryFileToFlightTypeAsync(String filename, int threadCount, QueryLocation queryLocation, int lineByteSize)


    // Initialise all UI elements
    // Set handlers to functions below
    //   For example, the "save" button should call saveQuery() when clicked
  }

  public void insertBaseData(FlightMultiDataType flightData) {
    m_flightsLists = flightData;
    m_onLoadDataEvent.accept(flightData.US);
    println("The first flights day in US: " + m_flightsLists.US[0].Day);
  }

  public void setOnLoadHandler(Consumer<FlightType[]> dataEvent) {
    m_onLoadDataEvent = dataEvent;
  }
  

  private void loadData() {

    // Apply all saved queries to m_flightLists and apply result to the Consumer (m_onLoadDataEvent.accept(result))

    FlightType[] result = null;
    if (m_dayQuery == null){
      result = m_flightsLists.US;
    }
    else{
      result  = m_queryManager.queryFlights(m_flightsLists.US, m_dayQuery, m_dayQuery.QueryValue);
    }
    
    //result = m_queryManager.getHead(m_flightsLists.WORLD , 10);
    println(m_dayQuery.QueryValue);
    m_onLoadDataEvent.accept(result);

  }

  private void saveQuery( TextboxUI inputTextbox) {
    // Saves currently written user input into a query
    m_dayQuery.setQueryValue(inputTextbox.getText());

    // Adds to query output field textbox thing
    m_queryList.add(inputTextbox.getText() );
    m_listCounter++;

    // Set all user inputs back to default
    m_day.setText("");
  }

  private void changeOperator(FlightQueryType input, QueryOperatorType inputOperator) {
    
    input.setOperator(inputOperator);
    
  }

  private void clearQueries() {
    // Clear all currently saved user queries
    m_dayQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, QueryLocationType.US, m_queryManager); 
    m_queryList.clear();

  }

  private void changeDataToUS() {

    m_location = QueryLocationType.US;
  }

  private void changeDataToWorld() {

    m_location = QueryLocationType.US;
  }


 

  private void addWidget(Widget widget) {
    m_screen.addWidget(widget);
    widget.setParent(this);
  }
}



// F.Wright  created Framework for UserQuery class 8pm 3/14/24
// M.Poole   fixed issue with key input not detecting and implemented Listbox Functionality
// M.Poole   implemented single item search querying 
