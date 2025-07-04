// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/exercicio_model.dart';
import 'models/ficha_model.dart';
import 'models/user_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
    id: const obx_int.IdUid(1, 3730207614500060661),
    name: 'Exercicio',
    lastPropertyId: const obx_int.IdUid(6, 943439504384151127),
    flags: 0,
    properties: <obx_int.ModelProperty>[
      obx_int.ModelProperty(
        id: const obx_int.IdUid(1, 795786516653758274),
        name: 'id',
        type: 6,
        flags: 1,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(2, 3429361075056800770),
        name: 'nome',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(3, 599483377609773589),
        name: 'musculoAlvo',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(4, 5412535689682827506),
        name: 'series',
        type: 6,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(5, 5251216810958037320),
        name: 'repeticoes',
        type: 6,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(6, 943439504384151127),
        name: 'fichaId',
        type: 11,
        flags: 520,
        indexId: const obx_int.IdUid(1, 8053598421654225609),
        relationTarget: 'Ficha',
      ),
    ],
    relations: <obx_int.ModelRelation>[],
    backlinks: <obx_int.ModelBacklink>[],
  ),
  obx_int.ModelEntity(
    id: const obx_int.IdUid(2, 6192234135157461721),
    name: 'Ficha',
    lastPropertyId: const obx_int.IdUid(3, 6982914816362130500),
    flags: 0,
    properties: <obx_int.ModelProperty>[
      obx_int.ModelProperty(
        id: const obx_int.IdUid(1, 2376668638858384427),
        name: 'id',
        type: 6,
        flags: 1,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(2, 5372589789326879686),
        name: 'titulo',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(3, 6982914816362130500),
        name: 'usuarioId',
        type: 11,
        flags: 520,
        indexId: const obx_int.IdUid(2, 5455036899753693929),
        relationTarget: 'Usuario',
      ),
    ],
    relations: <obx_int.ModelRelation>[
      obx_int.ModelRelation(
        id: const obx_int.IdUid(1, 699489905423119256),
        name: 'exercicios',
        targetId: const obx_int.IdUid(1, 3730207614500060661),
      ),
    ],
    backlinks: <obx_int.ModelBacklink>[],
  ),
  obx_int.ModelEntity(
    id: const obx_int.IdUid(3, 6232979796326521108),
    name: 'Usuario',
    lastPropertyId: const obx_int.IdUid(4, 3215014983567437591),
    flags: 0,
    properties: <obx_int.ModelProperty>[
      obx_int.ModelProperty(
        id: const obx_int.IdUid(1, 8360539039409234575),
        name: 'id',
        type: 6,
        flags: 1,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(2, 9136357695803670635),
        name: 'nome',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(3, 6997175401049520785),
        name: 'email',
        type: 9,
        flags: 0,
      ),
      obx_int.ModelProperty(
        id: const obx_int.IdUid(4, 3215014983567437591),
        name: 'password',
        type: 9,
        flags: 0,
      ),
    ],
    relations: <obx_int.ModelRelation>[],
    backlinks: <obx_int.ModelBacklink>[
      obx_int.ModelBacklink(name: 'fichas', srcEntity: 'Ficha', srcField: ''),
    ],
  ),
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore({
  String? directory,
  int? maxDBSizeInKB,
  int? maxDataSizeInKB,
  int? fileMode,
  int? maxReaders,
  bool queriesCaseSensitiveDefault = true,
  String? macosApplicationGroup,
}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(
    getObjectBoxModel(),
    directory: directory ?? (await defaultStoreDirectory()).path,
    maxDBSizeInKB: maxDBSizeInKB,
    maxDataSizeInKB: maxDataSizeInKB,
    fileMode: fileMode,
    maxReaders: maxReaders,
    queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
    macosApplicationGroup: macosApplicationGroup,
  );
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
    entities: _entities,
    lastEntityId: const obx_int.IdUid(3, 6232979796326521108),
    lastIndexId: const obx_int.IdUid(2, 5455036899753693929),
    lastRelationId: const obx_int.IdUid(2, 2077406152030735232),
    lastSequenceId: const obx_int.IdUid(0, 0),
    retiredEntityUids: const [],
    retiredIndexUids: const [],
    retiredPropertyUids: const [],
    retiredRelationUids: const [2077406152030735232],
    modelVersion: 5,
    modelVersionParserMinimum: 5,
    version: 1,
  );

  final bindings = <Type, obx_int.EntityDefinition>{
    Exercicio: obx_int.EntityDefinition<Exercicio>(
      model: _entities[0],
      toOneRelations: (Exercicio object) => [object.ficha],
      toManyRelations: (Exercicio object) => {},
      getId: (Exercicio object) => object.id,
      setId: (Exercicio object, int id) {
        object.id = id;
      },
      objectToFB: (Exercicio object, fb.Builder fbb) {
        final nomeOffset = fbb.writeString(object.nome);
        final musculoAlvoOffset = fbb.writeString(object.musculoAlvo);
        fbb.startTable(7);
        fbb.addInt64(0, object.id);
        fbb.addOffset(1, nomeOffset);
        fbb.addOffset(2, musculoAlvoOffset);
        fbb.addInt64(3, object.series);
        fbb.addInt64(4, object.repeticoes);
        fbb.addInt64(5, object.ficha.targetId);
        fbb.finish(fbb.endTable());
        return object.id;
      },
      objectFromFB: (obx.Store store, ByteData fbData) {
        final buffer = fb.BufferContext(fbData);
        final rootOffset = buffer.derefObject(0);
        final nomeParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGet(buffer, rootOffset, 6, '');
        final musculoAlvoParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGet(buffer, rootOffset, 8, '');
        final seriesParam = const fb.Int64Reader().vTableGet(
          buffer,
          rootOffset,
          10,
          0,
        );
        final repeticoesParam = const fb.Int64Reader().vTableGet(
          buffer,
          rootOffset,
          12,
          0,
        );
        final object = Exercicio(
          nome: nomeParam,
          musculoAlvo: musculoAlvoParam,
          series: seriesParam,
          repeticoes: repeticoesParam,
        )..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
        object.ficha.targetId = const fb.Int64Reader().vTableGet(
          buffer,
          rootOffset,
          14,
          0,
        );
        object.ficha.attach(store);
        return object;
      },
    ),
    Ficha: obx_int.EntityDefinition<Ficha>(
      model: _entities[1],
      toOneRelations: (Ficha object) => [object.usuario],
      toManyRelations: (Ficha object) => {
        obx_int.RelInfo<Ficha>.toMany(1, object.id): object.exercicios,
      },
      getId: (Ficha object) => object.id,
      setId: (Ficha object, int id) {
        object.id = id;
      },
      objectToFB: (Ficha object, fb.Builder fbb) {
        final tituloOffset = fbb.writeString(object.titulo);
        fbb.startTable(4);
        fbb.addInt64(0, object.id);
        fbb.addOffset(1, tituloOffset);
        fbb.addInt64(2, object.usuario.targetId);
        fbb.finish(fbb.endTable());
        return object.id;
      },
      objectFromFB: (obx.Store store, ByteData fbData) {
        final buffer = fb.BufferContext(fbData);
        final rootOffset = buffer.derefObject(0);
        final tituloParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGet(buffer, rootOffset, 6, '');
        final object = Ficha(titulo: tituloParam)
          ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
        object.usuario.targetId = const fb.Int64Reader().vTableGet(
          buffer,
          rootOffset,
          8,
          0,
        );
        object.usuario.attach(store);
        obx_int.InternalToManyAccess.setRelInfo<Ficha>(
          object.exercicios,
          store,
          obx_int.RelInfo<Ficha>.toMany(1, object.id),
        );
        return object;
      },
    ),
    Usuario: obx_int.EntityDefinition<Usuario>(
      model: _entities[2],
      toOneRelations: (Usuario object) => [],
      toManyRelations: (Usuario object) => {
        obx_int.RelInfo<Ficha>.toOneBacklink(
          3,
          object.id,
          (Ficha srcObject) => srcObject.usuario,
        ): object.fichas,
      },
      getId: (Usuario object) => object.id,
      setId: (Usuario object, int id) {
        object.id = id;
      },
      objectToFB: (Usuario object, fb.Builder fbb) {
        final nomeOffset = fbb.writeString(object.nome);
        final emailOffset = fbb.writeString(object.email);
        final passwordOffset = fbb.writeString(object.password);
        fbb.startTable(5);
        fbb.addInt64(0, object.id);
        fbb.addOffset(1, nomeOffset);
        fbb.addOffset(2, emailOffset);
        fbb.addOffset(3, passwordOffset);
        fbb.finish(fbb.endTable());
        return object.id;
      },
      objectFromFB: (obx.Store store, ByteData fbData) {
        final buffer = fb.BufferContext(fbData);
        final rootOffset = buffer.derefObject(0);
        final idParam = const fb.Int64Reader().vTableGet(
          buffer,
          rootOffset,
          4,
          0,
        );
        final nomeParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGet(buffer, rootOffset, 6, '');
        final emailParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGet(buffer, rootOffset, 8, '');
        final passwordParam = const fb.StringReader(
          asciiOptimization: true,
        ).vTableGet(buffer, rootOffset, 10, '');
        final object = Usuario(
          id: idParam,
          nome: nomeParam,
          email: emailParam,
          password: passwordParam,
        );
        obx_int.InternalToManyAccess.setRelInfo<Usuario>(
          object.fichas,
          store,
          obx_int.RelInfo<Ficha>.toOneBacklink(
            3,
            object.id,
            (Ficha srcObject) => srcObject.usuario,
          ),
        );
        return object;
      },
    ),
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Exercicio] entity fields to define ObjectBox queries.
class Exercicio_ {
  /// See [Exercicio.id].
  static final id = obx.QueryIntegerProperty<Exercicio>(
    _entities[0].properties[0],
  );

  /// See [Exercicio.nome].
  static final nome = obx.QueryStringProperty<Exercicio>(
    _entities[0].properties[1],
  );

  /// See [Exercicio.musculoAlvo].
  static final musculoAlvo = obx.QueryStringProperty<Exercicio>(
    _entities[0].properties[2],
  );

  /// See [Exercicio.series].
  static final series = obx.QueryIntegerProperty<Exercicio>(
    _entities[0].properties[3],
  );

  /// See [Exercicio.repeticoes].
  static final repeticoes = obx.QueryIntegerProperty<Exercicio>(
    _entities[0].properties[4],
  );

  /// See [Exercicio.ficha].
  static final ficha = obx.QueryRelationToOne<Exercicio, Ficha>(
    _entities[0].properties[5],
  );
}

/// [Ficha] entity fields to define ObjectBox queries.
class Ficha_ {
  /// See [Ficha.id].
  static final id = obx.QueryIntegerProperty<Ficha>(_entities[1].properties[0]);

  /// See [Ficha.titulo].
  static final titulo = obx.QueryStringProperty<Ficha>(
    _entities[1].properties[1],
  );

  /// See [Ficha.usuario].
  static final usuario = obx.QueryRelationToOne<Ficha, Usuario>(
    _entities[1].properties[2],
  );

  /// see [Ficha.exercicios]
  static final exercicios = obx.QueryRelationToMany<Ficha, Exercicio>(
    _entities[1].relations[0],
  );
}

/// [Usuario] entity fields to define ObjectBox queries.
class Usuario_ {
  /// See [Usuario.id].
  static final id = obx.QueryIntegerProperty<Usuario>(
    _entities[2].properties[0],
  );

  /// See [Usuario.nome].
  static final nome = obx.QueryStringProperty<Usuario>(
    _entities[2].properties[1],
  );

  /// See [Usuario.email].
  static final email = obx.QueryStringProperty<Usuario>(
    _entities[2].properties[2],
  );

  /// See [Usuario.password].
  static final password = obx.QueryStringProperty<Usuario>(
    _entities[2].properties[3],
  );

  /// see [Usuario.fichas]
  static final fichas = obx.QueryBacklinkToMany<Ficha, Usuario>(Ficha_.usuario);
}
