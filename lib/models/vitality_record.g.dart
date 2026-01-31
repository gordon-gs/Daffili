// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitality_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVitalityRecordCollection on Isar {
  IsarCollection<VitalityRecord> get vitalityRecords => this.collection();
}

const VitalityRecordSchema = CollectionSchema(
  name: r'VitalityRecord',
  id: 4723274743207674971,
  properties: {
    r'activityType': PropertySchema(
      id: 0,
      name: r'activityType',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'fatigueScore': PropertySchema(
      id: 2,
      name: r'fatigueScore',
      type: IsarType.long,
    ),
    r'isAnalyzed': PropertySchema(
      id: 3,
      name: r'isAnalyzed',
      type: IsarType.bool,
    ),
    r'moodLevel': PropertySchema(
      id: 4,
      name: r'moodLevel',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'rhythmIntensity': PropertySchema(
      id: 6,
      name: r'rhythmIntensity',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 7,
      name: r'timestamp',
      type: IsarType.long,
    )
  },
  estimateSize: _vitalityRecordEstimateSize,
  serialize: _vitalityRecordSerialize,
  deserialize: _vitalityRecordDeserialize,
  deserializeProp: _vitalityRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'moodLevel': IndexSchema(
      id: 4850808214183616937,
      name: r'moodLevel',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'moodLevel',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'fatigueScore': IndexSchema(
      id: 8917133155707664674,
      name: r'fatigueScore',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'fatigueScore',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'activityType': IndexSchema(
      id: 1012544980970652462,
      name: r'activityType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'activityType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'isAnalyzed': IndexSchema(
      id: 3522674644751104681,
      name: r'isAnalyzed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isAnalyzed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _vitalityRecordGetId,
  getLinks: _vitalityRecordGetLinks,
  attach: _vitalityRecordAttach,
  version: '3.1.0+1',
);

int _vitalityRecordEstimateSize(
  VitalityRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activityType.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _vitalityRecordSerialize(
  VitalityRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activityType);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.fatigueScore);
  writer.writeBool(offsets[3], object.isAnalyzed);
  writer.writeLong(offsets[4], object.moodLevel);
  writer.writeString(offsets[5], object.notes);
  writer.writeLong(offsets[6], object.rhythmIntensity);
  writer.writeLong(offsets[7], object.timestamp);
}

VitalityRecord _vitalityRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VitalityRecord();
  object.activityType = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.fatigueScore = reader.readLong(offsets[2]);
  object.id = id;
  object.isAnalyzed = reader.readBool(offsets[3]);
  object.moodLevel = reader.readLong(offsets[4]);
  object.notes = reader.readStringOrNull(offsets[5]);
  object.rhythmIntensity = reader.readLongOrNull(offsets[6]);
  object.timestamp = reader.readLong(offsets[7]);
  return object;
}

P _vitalityRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _vitalityRecordGetId(VitalityRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _vitalityRecordGetLinks(VitalityRecord object) {
  return [];
}

void _vitalityRecordAttach(
    IsarCollection<dynamic> col, Id id, VitalityRecord object) {
  object.id = id;
}

extension VitalityRecordQueryWhereSort
    on QueryBuilder<VitalityRecord, VitalityRecord, QWhere> {
  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhere> anyMoodLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'moodLevel'),
      );
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhere> anyFatigueScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'fatigueScore'),
      );
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhere> anyIsAnalyzed() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isAnalyzed'),
      );
    });
  }
}

extension VitalityRecordQueryWhere
    on QueryBuilder<VitalityRecord, VitalityRecord, QWhereClause> {
  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      moodLevelEqualTo(int moodLevel) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'moodLevel',
        value: [moodLevel],
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      moodLevelNotEqualTo(int moodLevel) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moodLevel',
              lower: [],
              upper: [moodLevel],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moodLevel',
              lower: [moodLevel],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moodLevel',
              lower: [moodLevel],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moodLevel',
              lower: [],
              upper: [moodLevel],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      moodLevelGreaterThan(
    int moodLevel, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'moodLevel',
        lower: [moodLevel],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      moodLevelLessThan(
    int moodLevel, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'moodLevel',
        lower: [],
        upper: [moodLevel],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      moodLevelBetween(
    int lowerMoodLevel,
    int upperMoodLevel, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'moodLevel',
        lower: [lowerMoodLevel],
        includeLower: includeLower,
        upper: [upperMoodLevel],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      fatigueScoreEqualTo(int fatigueScore) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'fatigueScore',
        value: [fatigueScore],
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      fatigueScoreNotEqualTo(int fatigueScore) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fatigueScore',
              lower: [],
              upper: [fatigueScore],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fatigueScore',
              lower: [fatigueScore],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fatigueScore',
              lower: [fatigueScore],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fatigueScore',
              lower: [],
              upper: [fatigueScore],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      fatigueScoreGreaterThan(
    int fatigueScore, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fatigueScore',
        lower: [fatigueScore],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      fatigueScoreLessThan(
    int fatigueScore, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fatigueScore',
        lower: [],
        upper: [fatigueScore],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      fatigueScoreBetween(
    int lowerFatigueScore,
    int upperFatigueScore, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fatigueScore',
        lower: [lowerFatigueScore],
        includeLower: includeLower,
        upper: [upperFatigueScore],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      activityTypeEqualTo(String activityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'activityType',
        value: [activityType],
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      activityTypeNotEqualTo(String activityType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [],
              upper: [activityType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [activityType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [activityType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [],
              upper: [activityType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      isAnalyzedEqualTo(bool isAnalyzed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isAnalyzed',
        value: [isAnalyzed],
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterWhereClause>
      isAnalyzedNotEqualTo(bool isAnalyzed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAnalyzed',
              lower: [],
              upper: [isAnalyzed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAnalyzed',
              lower: [isAnalyzed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAnalyzed',
              lower: [isAnalyzed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAnalyzed',
              lower: [],
              upper: [isAnalyzed],
              includeUpper: false,
            ));
      }
    });
  }
}

extension VitalityRecordQueryFilter
    on QueryBuilder<VitalityRecord, VitalityRecord, QFilterCondition> {
  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityType',
        value: '',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      activityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityType',
        value: '',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      fatigueScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatigueScore',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      fatigueScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatigueScore',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      fatigueScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatigueScore',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      fatigueScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatigueScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      isAnalyzedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAnalyzed',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      moodLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      moodLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      moodLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      moodLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
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

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
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

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
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

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
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

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
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

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
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

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      rhythmIntensityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rhythmIntensity',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      rhythmIntensityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rhythmIntensity',
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      rhythmIntensityEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rhythmIntensity',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      rhythmIntensityGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rhythmIntensity',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      rhythmIntensityLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rhythmIntensity',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      rhythmIntensityBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rhythmIntensity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      timestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      timestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      timestampLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterFilterCondition>
      timestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VitalityRecordQueryObject
    on QueryBuilder<VitalityRecord, VitalityRecord, QFilterCondition> {}

extension VitalityRecordQueryLinks
    on QueryBuilder<VitalityRecord, VitalityRecord, QFilterCondition> {}

extension VitalityRecordQuerySortBy
    on QueryBuilder<VitalityRecord, VitalityRecord, QSortBy> {
  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByActivityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByActivityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByFatigueScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueScore', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByFatigueScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueScore', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByIsAnalyzed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnalyzed', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByIsAnalyzedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnalyzed', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> sortByMoodLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodLevel', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByMoodLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodLevel', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByRhythmIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rhythmIntensity', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByRhythmIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rhythmIntensity', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension VitalityRecordQuerySortThenBy
    on QueryBuilder<VitalityRecord, VitalityRecord, QSortThenBy> {
  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByActivityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByActivityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByFatigueScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueScore', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByFatigueScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatigueScore', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByIsAnalyzed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnalyzed', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByIsAnalyzedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnalyzed', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> thenByMoodLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodLevel', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByMoodLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodLevel', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByRhythmIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rhythmIntensity', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByRhythmIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rhythmIntensity', Sort.desc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension VitalityRecordQueryWhereDistinct
    on QueryBuilder<VitalityRecord, VitalityRecord, QDistinct> {
  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct>
      distinctByActivityType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct>
      distinctByFatigueScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatigueScore');
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct>
      distinctByIsAnalyzed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAnalyzed');
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct>
      distinctByMoodLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodLevel');
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct>
      distinctByRhythmIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rhythmIntensity');
    });
  }

  QueryBuilder<VitalityRecord, VitalityRecord, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension VitalityRecordQueryProperty
    on QueryBuilder<VitalityRecord, VitalityRecord, QQueryProperty> {
  QueryBuilder<VitalityRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VitalityRecord, String, QQueryOperations>
      activityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityType');
    });
  }

  QueryBuilder<VitalityRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<VitalityRecord, int, QQueryOperations> fatigueScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatigueScore');
    });
  }

  QueryBuilder<VitalityRecord, bool, QQueryOperations> isAnalyzedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAnalyzed');
    });
  }

  QueryBuilder<VitalityRecord, int, QQueryOperations> moodLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodLevel');
    });
  }

  QueryBuilder<VitalityRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<VitalityRecord, int?, QQueryOperations>
      rhythmIntensityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rhythmIntensity');
    });
  }

  QueryBuilder<VitalityRecord, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
