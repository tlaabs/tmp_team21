package com.team21.project;

import java.text.DateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.google.gson.JsonParser;
import com.pusher.rest.Pusher;
import com.team21.util.DrawPkg;
import com.team21.util.HistoryPkg;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	static private Pusher pusher;

	static {
		pusher = new Pusher("636752", "9aad0be92f1331f371c5", "49a115d520877bac1a60");
		pusher.setCluster("ap1");
		pusher.setEncrypted(true);
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String homeGET(Locale locale, Model model) {
		return "home";
	}

	@RequestMapping(value = "/room", method = RequestMethod.POST)
	public String pusherTest(HttpServletRequest request, Model model) {
		String channel = request.getParameter("channel");
		String nickname = request.getParameter("nickname");

		model.addAttribute("channel", channel);
		model.addAttribute("nickname", nickname);
		return "pusher";
	}

	@RequestMapping(value = "/event", method = RequestMethod.POST)
	public void message(HttpServletRequest request, int xs[], int ys[]) {
		String channel = request.getParameter("channel");
		String nickname = request.getParameter("nickname");

		System.out.println("nickname : " + nickname);

		DrawPkg pkg = new DrawPkg(xs, ys);
		pusher.trigger(channel, "event", Collections.singletonMap("pos", pkg));

		System.out.println("x : " + xs.length);
		System.out.println("y : " + ys.length);
	}

	@RequestMapping(value = "/chat", method = RequestMethod.POST)
	public void chat(HttpServletRequest request) {
		String channel = request.getParameter("channel");
		String nickname = request.getParameter("nickname");
		String msg = nickname + " : " + request.getParameter("msg");

		pusher.trigger(channel, "chat", Collections.singletonMap("msg", msg));
	}

	@RequestMapping(value = "/enter", method = RequestMethod.POST)
	public void enter(HttpServletRequest request) {
		String channel = request.getParameter("channel");
		String nickname = request.getParameter("nickname");
		String msg = "[ " + nickname + " ]" + " : " + "님이 입장하셨습니다.";

		pusher.trigger(channel, "enter", Collections.singletonMap("msg", msg));
		pusher.trigger(channel, "broadcast", Collections.singletonMap("-", "-"));

	}

	@RequestMapping(value = "/broadcast", method = RequestMethod.POST)
	public void broadcast(HttpServletRequest request) {
		String channel = request.getParameter("channel");
		String nickname = request.getParameter("nickname");
		String xs = request.getParameter("xs");
		String ys = request.getParameter("ys");
		
		int[][] xsArrays = HistoryJsonToArray(xs);
		int[][] ysArrays = HistoryJsonToArray(ys);
		
		HistoryPkg pkg = new HistoryPkg(xsArrays, ysArrays);
		pusher.trigger(channel, "broadcastRecv", Collections.singletonMap("history", pkg));

//		System.out.println("배열x : " + xs);
//		System.out.println("배열y : " + ys);

	}

	private int[][] HistoryJsonToArray(String src) {

		int[][] arr = null;
		try {
			JSONArray array = new JSONArray(src);
			arr = new int[array.length()][];
			for (int i = 0; i < array.length(); i++) {
				JSONArray inner = array.getJSONArray(i);
				int[] innerArr = new int[inner.length()];
				for (int k = 0; k < inner.length(); k++) {
					innerArr[k] = inner.getInt(k);
					// System.out.println(inner.getInt(k));
				}
				arr[i] = innerArr;
				// System.out.println("inner : " + inner);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return arr;
	}

}
