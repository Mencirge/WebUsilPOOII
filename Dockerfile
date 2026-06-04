FROM tomcat:10.1-jdk17-temurin

# Remover la aplicación por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copiar el archivo WAR generado en la carpeta 'dist' por el build de NetBeans/Ant
# Se renombra a ROOT.war para que la app se cargue en la raíz (/) del sitio web
COPY dist/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponer el puerto por defecto de Tomcat
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
