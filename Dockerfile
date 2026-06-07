FROM tomcat:10.1-jdk17-temurin

# Deshabilitar el puerto de apagado (shutdown port 8005) de Tomcat para evitar advertencias en Render
RUN sed -i 's/port="8005"/port="-1"/g' /usr/local/tomcat/conf/server.xml

# Remover la aplicación por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copiar el archivo WAR generado en la carpeta 'dist' por el build de NetBeans/Ant
# Se renombra a ROOT.war para que la app se cargue en la raíz (/) del sitio web
COPY dist/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponer el puerto por defecto de Tomcat
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
