local env = std.extVar('qbec.io/env');

local paramsMap = {
  stage: import './environments/stage.libsonnet',
  prod: import './environments/prod.libsonnet',
};

if std.objectHas(paramsMap, env) then paramsMap[env] else error 'environment ' + env + ' not defined in ' + std.thisFile
