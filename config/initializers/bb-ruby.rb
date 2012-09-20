BBRuby.tag_list['YouTube (moar)'] = [
  /\[youtube\](?:https??:\/\/)?(?:www\.)?youtu(?:\.be\/|be\.com\/watch\?v=)([A-Z0-9\-_]+)(?:&(.*?))?\[\/youtube\]/im,
  '<object width="320" height="265"><param name="movie" value="http://www.youtube.com/v/\1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/\1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="320" height="265"></embed></object>',
  'Display a video from YouTube.com (alternative format)', 
    '[youtube]http://youtube.com/watch/v/E4Fbk52Mk1w[/youtube]',
    :video ]