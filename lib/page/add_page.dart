import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geotask/model/todo_model.dart';
import 'package:geotask/provider/todo_provider.dart';
import 'package:geotask/service/addTodoService.dart';
import 'package:geotask/page/location_selector.dart';
import 'package:intl/intl.dart';
import 'package:geotask/model/weather_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  // Mock data (This part is copied from the weather page)
  static WeatherNow todayWeather = WeatherNow(
    condition: Icons.thunderstorm,
    temperature: 25,
    feelLike: 44,
    pressure: 1013,
    humidity: 60,
    precip: 0,
    wind: WeatherWind(
      windSpeed: 10,
      windDirection: 45,
    ),
  );

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final dateFormatter = DateFormat.yMd();
  final timeFormatter = DateFormat.Hm();
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDateController.text = dateFormatter.format(DateTime.now());
    _endDateController.text = dateFormatter.format(DateTime.now());
    _startTimeController.text = timeFormatter.format(DateTime.now());
    _endTimeController.text = timeFormatter.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Add',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton:
            Consumer<TodoProvider>(builder: (context, todoProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world, you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );

                var startYMD =
                    DateFormat.yMd().parse(_startDateController.text);
                var startHM = DateFormat.Hm().parse(_startTimeController.text);
                var endYMD = DateFormat.yMd().parse(_endDateController.text);
                var endHM = DateFormat.Hm().parse(_endTimeController.text);

                // Combine timestamp with title for Unique
                String Id =
                    '${_titleController.text}-${DateTime.now().millisecondsSinceEpoch}';

                Todo newTodo = Todo(
                    title: _titleController.text,
                    locationName: _locationController.text,
                    subtitle: _detailsController.text,
                    startTime: startYMD.add(
                        Duration(hours: startHM.hour, minutes: startHM.minute)),
                    endTime: endYMD.add(
                        Duration(hours: endHM.hour, minutes: endHM.minute)),
                    //TODO ADD LATLONG
                    id: Id);

                // Add todo to provider
                todoProvider.addTodo(newTodo);

                // Add todo to firebase
                addTodo(Id, newTodo);

                Navigator.pop(context);
              }
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          );
        }),
        body: Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Add Title'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text("Start Time",
                      style: Theme.of(context).textTheme.labelLarge),
                  DateInput(
                    dateController: _startDateController,
                  ),
                  TimeInput(
                    timeController: _startTimeController,
                  ),
                  Text("End Time",
                      style: Theme.of(context).textTheme.labelLarge),
                  DateInput(
                    dateController: _endDateController,
                  ),
                  TimeInput(timeController: _endTimeController),
                  LocationInput(
                    locationController: _locationController,
                  ),
                  TextFormField(
                    maxLines: 10,
                    controller: _detailsController,
                    decoration: const InputDecoration(
                        hintText: "Add Details",
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none),
                  ),
                ]),
          ),
        ));
  }
}

class TimeInput extends StatefulWidget {
  const TimeInput({
    super.key,
    TextEditingController? timeController,
  }) : _timeController = timeController;

  final TextEditingController? _timeController;

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget._timeController ??
        TextEditingController(text: DateFormat.jm().format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller!,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(16),
        prefixIcon: Icon(Icons.access_time_rounded),
      ),
      enableInteractiveSelection: false,
      onTap: () async {
        var result = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());

        if (result != null) {
          _controller!.text = result.format(context);
        }
        // deselect
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}

class DateInput extends StatefulWidget {
  const DateInput({
    super.key,
    TextEditingController? dateController,
  }) : _dateController = dateController;

  final TextEditingController? _dateController;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget._dateController ??
        TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller!,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(16),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.calendar_today),
      ),
      enableInteractiveSelection: false,
      onTap: () async {
        var result = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (result != null) {
          _controller!.text = DateFormat.yMd().format(result);
        }

        // deselect
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    TextEditingController? locationController,
  }) : _locationController = locationController;

  final TextEditingController? _locationController;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  TextEditingController? _controller;
  LatLng? _locationCoord;

  @override
  void initState() {
    super.initState();

    _controller = widget._locationController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller!,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              hintText: 'Add Location',
              prefixIcon: Icon(Icons.location_on),
            ),
            onTap: () {
              if (_controller?.text.isEmpty ?? true) {
                // Open location selector page
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationSelectorPage()))
                    .then((value) {
                  if (value != null) {
                    var location = value as List;
                    var locationName = location[1] as String;
                    var locationCoord = location[0] as LatLng;
                    setState(() => _locationCoord = locationCoord);
                    _controller!.text = locationName;
                  }
                });
              }
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            // Open location selector page
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocationSelectorPage()))
                .then((value) {
              if (value != null) {
                var location = value as List;
                var locationName = location[1] as String;
                var locationCoord = location[0] as LatLng;
                setState(() => _locationCoord = locationCoord);
                _controller!.text = locationName;
              }
            });
          },
          child: const Icon(Icons.map),
        ),
        Container(
            margin: const EdgeInsets.only(left: 10),
            child: _locationCoord == null
                ? const Text('')
                : Text(
                    '${_locationCoord!.latitude.toStringAsFixed(6)}, ${_locationCoord!.longitude.toStringAsFixed(6)}'))
        // child: Text('${_locationCoord.latitude.toStringAsFixed(6)}, ${_locationCoord.longitude.toStringAsFixed(6)}'))
      ],
    );
  }
}
