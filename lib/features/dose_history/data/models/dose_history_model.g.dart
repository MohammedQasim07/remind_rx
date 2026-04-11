// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_history_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDoseHistoryModelCollection on Isar {
  IsarCollection<DoseHistoryModel> get doseHistoryModels => this.collection();
}

const DoseHistoryModelSchema = CollectionSchema(
  name: r'DoseHistoryModel',
  id: -6124472401111034842,
  properties: {
    r'actualTime': PropertySchema(
      id: 0,
      name: r'actualTime',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'medicineId': PropertySchema(
      id: 2,
      name: r'medicineId',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'scheduleId': PropertySchema(
      id: 4,
      name: r'scheduleId',
      type: IsarType.string,
    ),
    r'scheduledTime': PropertySchema(
      id: 5,
      name: r'scheduledTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 6,
      name: r'status',
      type: IsarType.byte,
      enumMap: _DoseHistoryModelstatusEnumValueMap,
    ),
    r'userId': PropertySchema(
      id: 7,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _doseHistoryModelEstimateSize,
  serialize: _doseHistoryModelSerialize,
  deserialize: _doseHistoryModelDeserialize,
  deserializeProp: _doseHistoryModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'scheduleId': IndexSchema(
      id: 1899306264659753312,
      name: r'scheduleId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scheduleId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'medicineId': IndexSchema(
      id: 6094895651756910893,
      name: r'medicineId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'medicineId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'scheduledTime': IndexSchema(
      id: 4528483578431344364,
      name: r'scheduledTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scheduledTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _doseHistoryModelGetId,
  getLinks: _doseHistoryModelGetLinks,
  attach: _doseHistoryModelAttach,
  version: '3.1.0+1',
);

int _doseHistoryModelEstimateSize(
  DoseHistoryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.medicineId.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.scheduleId.length * 3;
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _doseHistoryModelSerialize(
  DoseHistoryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.actualTime);
  writer.writeString(offsets[1], object.id);
  writer.writeString(offsets[2], object.medicineId);
  writer.writeString(offsets[3], object.notes);
  writer.writeString(offsets[4], object.scheduleId);
  writer.writeDateTime(offsets[5], object.scheduledTime);
  writer.writeByte(offsets[6], object.status.index);
  writer.writeString(offsets[7], object.userId);
}

DoseHistoryModel _doseHistoryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DoseHistoryModel();
  object.actualTime = reader.readDateTimeOrNull(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.isarId = id;
  object.medicineId = reader.readString(offsets[2]);
  object.notes = reader.readStringOrNull(offsets[3]);
  object.scheduleId = reader.readString(offsets[4]);
  object.scheduledTime = reader.readDateTime(offsets[5]);
  object.status =
      _DoseHistoryModelstatusValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          DoseStatus.scheduled;
  object.userId = reader.readStringOrNull(offsets[7]);
  return object;
}

P _doseHistoryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (_DoseHistoryModelstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DoseStatus.scheduled) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DoseHistoryModelstatusEnumValueMap = {
  'scheduled': 0,
  'taken': 1,
  'missed': 2,
  'skipped': 3,
};
const _DoseHistoryModelstatusValueEnumMap = {
  0: DoseStatus.scheduled,
  1: DoseStatus.taken,
  2: DoseStatus.missed,
  3: DoseStatus.skipped,
};

Id _doseHistoryModelGetId(DoseHistoryModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _doseHistoryModelGetLinks(DoseHistoryModel object) {
  return [];
}

void _doseHistoryModelAttach(
    IsarCollection<dynamic> col, Id id, DoseHistoryModel object) {
  object.isarId = id;
}

extension DoseHistoryModelByIndex on IsarCollection<DoseHistoryModel> {
  Future<DoseHistoryModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  DoseHistoryModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<DoseHistoryModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<DoseHistoryModel?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(DoseHistoryModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(DoseHistoryModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<DoseHistoryModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<DoseHistoryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension DoseHistoryModelQueryWhereSort
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QWhere> {
  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhere>
      anyScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'scheduledTime'),
      );
    });
  }
}

extension DoseHistoryModelQueryWhere
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QWhereClause> {
  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      scheduleIdEqualTo(String scheduleId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scheduleId',
        value: [scheduleId],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      scheduleIdNotEqualTo(String scheduleId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [],
              upper: [scheduleId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [scheduleId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [scheduleId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [],
              upper: [scheduleId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      medicineIdEqualTo(String medicineId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'medicineId',
        value: [medicineId],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      medicineIdNotEqualTo(String medicineId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [],
              upper: [medicineId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [medicineId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [medicineId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [],
              upper: [medicineId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [null],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      userIdEqualTo(String? userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      userIdNotEqualTo(String? userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      scheduledTimeEqualTo(DateTime scheduledTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scheduledTime',
        value: [scheduledTime],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      scheduledTimeNotEqualTo(DateTime scheduledTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTime',
              lower: [],
              upper: [scheduledTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTime',
              lower: [scheduledTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTime',
              lower: [scheduledTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTime',
              lower: [],
              upper: [scheduledTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      scheduledTimeGreaterThan(
    DateTime scheduledTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledTime',
        lower: [scheduledTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      scheduledTimeLessThan(
    DateTime scheduledTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledTime',
        lower: [],
        upper: [scheduledTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterWhereClause>
      scheduledTimeBetween(
    DateTime lowerScheduledTime,
    DateTime upperScheduledTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledTime',
        lower: [lowerScheduledTime],
        includeLower: includeLower,
        upper: [upperScheduledTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DoseHistoryModelQueryFilter
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QFilterCondition> {
  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      actualTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualTime',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      actualTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualTime',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      actualTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      actualTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      actualTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      actualTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicineId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medicineId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineId',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      medicineIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medicineId',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduleId',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduledTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduledTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduledTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      scheduledTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      statusEqualTo(DoseStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      statusGreaterThan(
    DoseStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      statusLessThan(
    DoseStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      statusBetween(
    DoseStatus lower,
    DoseStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension DoseHistoryModelQueryObject
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QFilterCondition> {}

extension DoseHistoryModelQueryLinks
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QFilterCondition> {}

extension DoseHistoryModelQuerySortBy
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QSortBy> {
  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByActualTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension DoseHistoryModelQuerySortThenBy
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QSortThenBy> {
  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByActualTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension DoseHistoryModelQueryWhereDistinct
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct> {
  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct>
      distinctByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualTime');
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct>
      distinctByMedicineId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicineId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct>
      distinctByScheduleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct>
      distinctByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTime');
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<DoseHistoryModel, DoseHistoryModel, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension DoseHistoryModelQueryProperty
    on QueryBuilder<DoseHistoryModel, DoseHistoryModel, QQueryProperty> {
  QueryBuilder<DoseHistoryModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<DoseHistoryModel, DateTime?, QQueryOperations>
      actualTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualTime');
    });
  }

  QueryBuilder<DoseHistoryModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DoseHistoryModel, String, QQueryOperations>
      medicineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicineId');
    });
  }

  QueryBuilder<DoseHistoryModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<DoseHistoryModel, String, QQueryOperations>
      scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleId');
    });
  }

  QueryBuilder<DoseHistoryModel, DateTime, QQueryOperations>
      scheduledTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTime');
    });
  }

  QueryBuilder<DoseHistoryModel, DoseStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DoseHistoryModel, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoseHistoryModel _$DoseHistoryModelFromJson(Map<String, dynamic> json) =>
    DoseHistoryModel()
      ..id = json['id'] as String
      ..scheduleId = json['scheduleId'] as String
      ..medicineId = json['medicineId'] as String
      ..userId = json['userId'] as String?
      ..scheduledTime = DateTime.parse(json['scheduledDateTime'] as String)
      ..actualTime = json['takenDateTime'] == null
          ? null
          : DateTime.parse(json['takenDateTime'] as String)
      ..status = $enumDecode(_$DoseStatusEnumMap, json['status'])
      ..notes = json['notes'] as String?;

Map<String, dynamic> _$DoseHistoryModelToJson(DoseHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'medicineId': instance.medicineId,
      'userId': instance.userId,
      'scheduledDateTime': instance.scheduledTime.toIso8601String(),
      'takenDateTime': instance.actualTime?.toIso8601String(),
      'status': _$DoseStatusEnumMap[instance.status]!,
      'notes': instance.notes,
    };

const _$DoseStatusEnumMap = {
  DoseStatus.scheduled: 0,
  DoseStatus.taken: 1,
  DoseStatus.missed: 2,
  DoseStatus.skipped: 3,
};
