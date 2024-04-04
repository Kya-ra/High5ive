/**
 * M.Poole:
 * Represents a user interface for querying flight data. Manages user inputs and interactions
 * for querying flight data and displaying results.
 */
class UserQueryUI extends Widget {
  private Consumer<FlightType[]> m_onLoadDataEvent;

  QueryManagerClass m_queryManager;
  private ArrayList<FlightQueryType> m_activeQueries; // All query types are ordered like so (Day, Airline, FlightNum, Origin, Dest, SchDep, Dep, Depdelay, SchArr, Arr, ArrDelay, Cancelled, Dievrted, Miles  )
  private ArrayList<FlightQueryType> m_flightQueries;
  private ListboxUI m_queryList;
  private TextboxUI m_Origin;
  private TextboxUI m_Dest;
  private TextboxUI m_Distance;
  private TextboxUI m_Airline;
  private TextboxUI m_FlightNum;
  private DropdownUI m_DistanceOperator;
  private RadioButtonUI m_cancelledRadio;
  private RadioButtonUI m_divertedRadio;
  private RadioButtonUI m_successRadio;
  private RadioButtonUI m_worldRadio;
  private RadioButtonUI m_usRadio;
  private ButtonUI clearListButton;
  private ButtonUI removeSelectedButton;
  private ButtonUI addItemButton;
  private ButtonUI loadDataButton;

  private QueryLocationType m_location = QueryLocationType.US;

  public int m_listCounter;
  private FlightQueryType m_OriginQuery;
  private FlightQueryType m_DestQuery;
  private FlightQueryType m_DistanceQuery;
  private FlightQueryType m_CancelledQuery;
  private FlightQueryType m_DivertedQuery;
  private FlightQueryType m_AirlineQuery;
  private FlightQueryType m_FlightNumQuery;
  private Screen m_screen;
 

  private FlightMultiDataType m_flightsLists;

  /**
   * M.Poole:
   * Constructs a UserQueryUI object with the specified position, dimensions, query manager, and screen.
   *
   * @param posX         The x-coordinate of the user interface position.
   * @param posY         The y-coordinate of the user interface position.
   * @param scaleX       The width of the user interface.
   * @param scaleY       The height of the user interface.
   * @param queryManager The query manager responsible for handling flight data queries.
   * @param screen       The screen where the user interface will be displayed.
   */
  UserQueryUI(int posX, int posY, int scaleX, int scaleY, QueryManagerClass queryManager, Screen screen) {
    super(posX, posY, scaleX, scaleY);

    m_queryManager = queryManager;
    m_screen = screen;

    m_queryList = new ListboxUI<String>(20, 650, 200, 400, 40, v -> v);
    addWidget(m_queryList);

    m_flightQueries = new ArrayList<FlightQueryType>();
    m_activeQueries = new ArrayList<FlightQueryType>();

    RadioButtonGroupTypeUI worldUSGroup = new RadioButtonGroupTypeUI();
    addWidgetGroup(worldUSGroup);

    m_worldRadio = new RadioButtonUI(width - 60, 20, 50, 50, "WORLD");
    m_worldRadio.getOnCheckedEvent().addHandler(e -> changeDataToWorld());
    worldUSGroup.addMember(m_worldRadio);

    m_usRadio = new RadioButtonUI(width - 60, 80, 50, 50, "US");
    m_usRadio.getOnCheckedEvent().addHandler(e -> changeDataToUS());
    worldUSGroup.addMember(m_usRadio);
    m_usRadio.setChecked(true);

    RadioButtonGroupTypeUI cancelDivertGroup = new RadioButtonGroupTypeUI();
    addWidgetGroup(cancelDivertGroup);

    m_cancelledRadio = new RadioButtonUI(20, 300, 20, 20, "CANCELLED");
    addWidget(m_cancelledRadio);
    m_cancelledRadio.setUncheckable(true);
    cancelDivertGroup.addMember(m_cancelledRadio);

    m_divertedRadio = new RadioButtonUI(55, 300, 20, 20, "DIVERTED");
    addWidget(m_divertedRadio);
    m_divertedRadio.setUncheckable(true);
    cancelDivertGroup.addMember(m_divertedRadio);

    m_successRadio = new RadioButtonUI(90, 300, 20, 20, "SUCCESS");
    addWidget(m_successRadio);
    cancelDivertGroup.addMember(m_successRadio);
    m_successRadio.setUncheckable(true);

    LabelUI cancelLabel = createLabel(17, 250, 160, 50, "C      D      N");
    cancelLabel.setTextSize(15);
    cancelLabel.setCentreAligned(false);

    addItemButton = new ButtonUI(20, 600, 80, 20);
    addWidget(addItemButton);
    addItemButton.setText("Add item");
    addItemButton.getOnClickEvent().addHandler(e -> saveAllQueries());

    clearListButton = new ButtonUI(120, 600, 80, 20);
    addWidget(clearListButton);
    clearListButton.setText("Clear");
    clearListButton.getOnClickEvent().addHandler(e -> clearQueries());

    loadDataButton = new ButtonUI(220, 500, 180, 120);
    addWidget(loadDataButton);
    loadDataButton.setText("Load Data");
    loadDataButton.getOnClickEvent().addHandler(e -> loadData());

    m_Origin =  new TextboxUI(20, 500, 160, 30);
    addWidget(m_Origin);
    m_Origin.setPlaceholderText("Origin");

    m_OriginQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_OriginQuery);

    m_Dest =  new TextboxUI(20, 550, 160, 30);
    addWidget(m_Dest);
    m_Dest.setPlaceholderText("Destination");

    m_DestQuery = new FlightQueryType(QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_DestQuery);

    m_Distance =  new TextboxUI(20, 450, 160, 30);
    addWidget(m_Distance);
    m_Distance.setPlaceholderText("Kilometers ");

    m_DistanceQuery = new FlightQueryType(QueryType.KILOMETRES_DISTANCE, QueryOperatorType.LESS_THAN, m_location);
    m_flightQueries.add(m_DestQuery);

    m_Airline =  new TextboxUI(20, 360, 160, 30); //Throwing off screen until this works
    addWidget(m_Airline);
    m_Airline.setPlaceholderText("Airline");

    m_AirlineQuery = new FlightQueryType(QueryType.CARRIER_CODE_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_AirlineQuery);

    m_FlightNum =  new TextboxUI(20, 400, 160, 30);
    addWidget(m_FlightNum);
    m_FlightNum.setPlaceholderText("Flight Number");

    m_FlightNumQuery = new FlightQueryType(QueryType.FLIGHT_NUMBER, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_FlightNumQuery);

    m_CancelledQuery = new FlightQueryType(QueryType.CANCELLED, QueryOperatorType.NOT_EQUAL, m_location);
    m_flightQueries.add(m_CancelledQuery);
    m_CancelledQuery.setQueryValue(1);

    m_DivertedQuery = new FlightQueryType(QueryType.DIVERTED, QueryOperatorType.NOT_EQUAL, m_location);
    m_flightQueries.add(m_CancelledQuery);
    m_DivertedQuery.setQueryValue(1);
  }

  /**
   * M.Poole:
   * Inserts base flight data into the user interface for further querying and analysis.
   *
   * @param flightData The flight data to be inserted into the interface.
   */
  public void insertBaseData(FlightMultiDataType flightData) {
    m_flightsLists = flightData;
    m_onLoadDataEvent.accept(new FlightType[0]);
  }

  /**
   * M.Poole:
   * Sets the handler for the data load event. This event occurs when flight data needs to be loaded.
   *
   * @param dataEvent The event handler for loading flight data.
   */
  public void setOnLoadHandler(Consumer<FlightType[]> dataEvent) {
    m_onLoadDataEvent = dataEvent;
  }

  /**
   * M.Poole:
   * Loads flight data based on the active queries. Queries the flight manager for relevant data
   * based on user input queries and updates the displayed data accordingly.
   */
  private void loadData() {
    FlightType[] result;
    if (m_location == QueryLocationType.US)
      result = m_flightsLists.US;
    else
      result = m_flightsLists.WORLD;

    for (FlightQueryType query : m_activeQueries) {
      result  = m_queryManager.queryFlights(result, query, query.QueryValue);
    }

    s_DebugProfiler.startProfileTimer();
    m_onLoadDataEvent.accept(result);
    s_DebugProfiler.printTimeTakenMillis("User query event");
  }

  /**
   * M.Poole:
   * Saves a query based on the provided textbox and query type. Captures user input and saves
   * it as a query for loading data.
   *
   * @param inputField The input field containing the user query.
   * @param inputQuery The query to be saved.
   */
  private void saveQuery(TextboxUI inputField, FlightQueryType inputQuery) {
    if (inputField.getTextLength() <= 0)
      return;

    String text = inputField.getText().toUpperCase();
    inputField.setText("");

    int val = m_queryManager.formatQueryValue(inputQuery.Type, text);
    if (val == -1)
      return;

    inputQuery.setQueryValue(val);
    addToQueryList(inputQuery, inputQuery.Type.toString() + ": " + text);
  }

  private void addToQueryList(FlightQueryType query, String text) {
    m_activeQueries.add(query);
    m_queryList.add(text);
    m_listCounter++;
  }

  /**
   * M.Poole:
   * Saves all active queries entered by the user. Collects and stores all active queries
   * for loading data.
   */
  private void saveAllQueries() {
    saveQuery(m_Origin, m_OriginQuery);
    saveQuery(m_Dest, m_DestQuery);
    saveQuery(m_Distance, m_DistanceQuery);
    saveQuery(m_Airline, m_AirlineQuery);
    saveQuery(m_FlightNum, m_FlightNumQuery);

    if (m_cancelledRadio.getChecked()) {
      m_CancelledQuery.setOperator(QueryOperatorType.EQUAL);
      addToQueryList(m_CancelledQuery, "Cancelled");
    }

    if (m_divertedRadio.getChecked()) {
      m_DivertedQuery.setOperator(QueryOperatorType.EQUAL);
      addToQueryList(m_DivertedQuery, "Diverted");
    }

    if (m_successRadio.getChecked()) {
      m_CancelledQuery.setOperator(QueryOperatorType.NOT_EQUAL);
      m_DivertedQuery.setOperator(QueryOperatorType.NOT_EQUAL);
      addToQueryList(m_CancelledQuery, "Not Cancelled");
      addToQueryList(m_DivertedQuery, "Not Diverted");
    }
  }

  /**
   * M.Poole:
   * Changes the operator for a given query. Modifies the operator used in a query based
   * on user interaction or selection.
   *
   * @param input         The query for which the operator needs to be changed.
   * @param inputOperator The new operator for the query.
   */
  private void changeOperator(FlightQueryType input, QueryOperatorType inputOperator) {
    input.setOperator(inputOperator);
  }

  private void setOperators() {
  }

  /**
   * M.Poole:
   * Clears all currently saved user queries. Resets the interface by removing all
   * saved queries and resetting input fields.
   */
  private void clearQueries() {
    m_OriginQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, m_location);
    m_DestQuery = new FlightQueryType(QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL, m_location);
    m_DistanceQuery = new FlightQueryType(QueryType.KILOMETRES_DISTANCE, QueryOperatorType.LESS_THAN, m_location);
    m_AirlineQuery = new FlightQueryType(QueryType.CARRIER_CODE_INDEX, QueryOperatorType.EQUAL, m_location);
    m_FlightNumQuery = new FlightQueryType(QueryType.FLIGHT_NUMBER, QueryOperatorType.EQUAL, m_location);

    m_activeQueries.clear();
    m_queryList.clear();
  }

  /**
   * M.Poole:
   * Changes the data location to US. Updates the interface to reflect data relevant
   * to the United States.
   */
  private void changeDataToUS() {
    m_location = QueryLocationType.US;
  }

  /**
   * M.Poole:
   * Changes the data location to World. Updates the interface to reflect global data.
   */
  private void changeDataToWorld() {
    m_location = QueryLocationType.WORLD;
  }

  /**
   * M.Poole:
   * Adds a widget to the user interface. Incorporates a new widget into the interface layout
   * for user interaction and data display.
   *
   * @param widget The widget to be added to the interface.
   */
  private void addWidget(Widget widget) {
    m_screen.addWidget(widget);
    widget.setParent(this);
  }

  private void addWidgetGroup(WidgetGroupType group) {
    m_screen.addWidgetGroup(group);
  }

  public LabelUI createLabel(int posX, int posY, int scaleX, int scaleY, String text) {
    LabelUI label = new LabelUI(posX, posY, scaleX, scaleY, text);
    addWidget(label);
    return label;
  }

  public void setRenderWorldUSButtons(boolean enabled) {
    m_worldRadio.setRendering(enabled);
    m_usRadio.setRendering(enabled);
  }

  public void setWorldUSParent(Widget parent) {
    m_worldRadio.setParent(parent);
    m_usRadio.setParent(parent);
  }
}

// F.Wright  created Framework for UserQuery class 8pm 3/14/24
// M.Poole   fixed issue with key input not detecting and implemented Listbox Functionality
// M.Poole   implemented single item search querying
