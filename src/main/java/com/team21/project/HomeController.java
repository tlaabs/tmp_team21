package com.team21.project;

import java.text.DateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.pusher.rest.Pusher;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public String pusherTest() {		
		return "pusher";
	}
	
	@RequestMapping(value = "/event", method = RequestMethod.GET)
	public void message() {		
		Pusher pusher = new Pusher("636752", "9aad0be92f1331f371c5", "49a115d520877bac1a60");
		pusher.setCluster("ap1");
		pusher.setEncrypted(true);
//
		pusher.trigger("devsim", "event", Collections.singletonMap("message", "hello world"));
	}
	
	
	
}
