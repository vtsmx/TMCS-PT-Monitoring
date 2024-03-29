/*OPC UA Systems*/
module "opcuaSystem-1" {
  source = "./modules/opcuaSystem"
  opcuaSystemName = "opcuaSys1"
}
module "opcuaSystem-2"{
  source = "./modules/opcuaSystem"
  opcuaSystemName = "opcuaSys2"
}
module "opcuaSystem-3"{
  source = "./modules/opcuaSystem"
  opcuaSystemName = "opcuaSys3"
}

/*DB System*/
module "dbSystem" {
  source = "./modules/databaseSystem"
  dbSystemName = "dbSys1"
  dbPassword = var.dbPassword
}

/*Monitoring System*/
module "monitoringSystem" {
  source = "./modules/monitoringSystem"
  monitoringSystemName = "monitoringSys1"
  dbPassword = var.dbPassword
  dbUrl = module.dbSystem.dbIp
  grafanaPassword = var.grafanaPassword
}

/*WinCC Oa System*/
module "winccoaSystem" {
  source = "./modules/winccoaSystem"
  winccoaSystemName = "winccoaSys1"
  connectToOpcUaServers = "${module.opcuaSystem-1.opcuaIp}_${module.opcuaSystem-2.opcuaIp}_${module.opcuaSystem-3.opcuaIp}"
  dbHost = module.dbSystem.dbIp
  dbUser = var.dbUser
  dbPassword = var.dbPassword
  monitoringHost = module.monitoringSystem.monitoringIp
  grafanaPassword = var.grafanaPassword
}

output "DB-IP" {
  value = "http://${module.dbSystem.dbIp}:8080"
}

output "Grafana-URL" {
  value = "http://${module.monitoringSystem.monitoringIp}:3000"
}

output "Loki-URL" {
  value = "http://${module.monitoringSystem.monitoringIp}:3100"
}

output "JaegerHotrod-URL" {
  value = "http://${module.winccoaSystem.winccoaIp}:8080"
}