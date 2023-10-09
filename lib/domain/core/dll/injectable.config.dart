// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:social_media/api/api.dart' as _i3;
import 'package:social_media/domain/auth/i_auth_repo.dart' as _i4;
import 'package:social_media/domain/post/i_post_repo.dart' as _i6;
import 'package:social_media/infrastructure/auth/i_auth_repository.dart' as _i5;
import 'package:social_media/infrastructure/post/i_post_repository.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.Api>(() => _i3.Api());
    gh.lazySingleton<_i4.IAuthRepo>(() => _i5.AuthRepository(gh<_i3.Api>()));
    gh.lazySingleton<_i6.IPostRepo>(() => _i7.IPostRepository(gh<_i3.Api>()));
    return this;
  }
}
