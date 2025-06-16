import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/remote_data_source.dart';


class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),

  ];

  static final blocProviders = <BlocProvider>[

  ];
}
