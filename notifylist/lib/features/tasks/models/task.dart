import 'package:drift/drift.dart';


class Tasks extends Table{

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get categoryId => text()();

  // Fecha-Hora concretos (opcional)
  DateTimeColumn get scheduledDate => dateTime().nullable()();

  //Hora de inicio de la tarea (Opcional, se guarda en minutos desde las 00:00 medianoche - EJEMPLO: 12:00 => 720)
  IntColumn get startTime => integer().nullable()();

  // Hora de fin de la tarea (Opcional, se guarda en minutos desde medianoche - EJEMPLO: 14:00 => 840)
  IntColumn get endTime => integer().nullable()();

  // Dias de la semana que se repitira esta tarea (Opcional, se guardara en forma de String - EJEMPLO: "1,3,5" => Lunes, Miercoles, Viernes)
  TextColumn get weekDays => text().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  
}