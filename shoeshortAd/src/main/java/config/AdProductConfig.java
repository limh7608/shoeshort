package config;

import org.apache.tomcat.jdbc.pool.*;
import org.springframework.context.annotation.*;
import dao.*;
import svc.*;

@Configuration
public class AdProductConfig {
	@Bean(destroyMethod = "close")
	public DataSource dataSource() {
		DataSource ds = new DataSource();
		ds.setDriverClassName("com.mysql.jdbc.Driver");
		ds.setUrl("jdbc:mysql://localhost/shoeshort?characterEncoding=utf8");
		ds.setUsername("root");
		ds.setPassword("1234");
		ds.setInitialSize(2);
		ds.setMaxActive(10);
		ds.setTestWhileIdle(true);
		ds.setMinEvictableIdleTimeMillis(60000 * 3);
		ds.setTimeBetweenEvictionRunsMillis(10 * 1000);
		
		return ds;
	}
	@Bean
	public AdProductSvc adProductSvc() {
		AdProductSvc adProductSvc =new AdProductSvc();
		adProductSvc.setAdProductDao(adProductDao());
		return adProductSvc;
	}
	@Bean
	public AdProductDao adProductDao() {
		return new AdProductDao(dataSource());
	}
}
