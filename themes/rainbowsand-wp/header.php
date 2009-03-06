<!doctype html>
<html <?php language_attributes(); ?>>
 <head>
  <meta charset='UTF-8'>
  <meta name='verify-v1' content='fBP5k+EA4BFJx2aaK3hiOymbZSUbEAkp8OcEdeK/Fk8='>
  <meta name='keywords' content='stilist, ratafia, ratafia currant'>
  <title><?php wp_title(' — ', true, 'right'); ?><?php bloginfo('name'); ?></title>
  <link rel='icon' type='text/css'
        href='http://static.ratafia.info/favicon.ico'>
  <link rel='stylesheet' type='text/css' media='screen'
        href="<?php bloginfo('stylesheet_url'); ?>">
  <link rel='openid.server' href='http://www.myopenid.com/server'>
  <link rel='openid.delegate' href='http://stilist.myopenid.com/'>
  <link rel='openid2.local_id' href='http://stilist.myopenid.com'>
  <link rel='openid2.provider' href='http://www.myopenid.com/server'>
  <meta http-equiv='X-XRDS-Location'
        content='http://www.myopenid.com/xrds?username=stilist.myopenid.com'>
  <link rel='alternate' type='application/atom+xml' title='Ratafia Currant'
        href='http://feeds.feedburner.com/ratafia'>
  <?php if ( is_singular() ) { ?><link rel='canonical'
        href='<?php the_permalink(); ?>'><?php } ?>
 </head>
 <body>
  <div id='wrapper'>
   <ul id='nameplate'>
    <li id='logo'><a href='<?php echo get_option('home'); ?>/' rel='home'><?php bloginfo('name'); ?></a></li>
    <li><a href='/archive.php' id='archives'>Archives</a></li>
    <li><a href='http://github.com/stilist' id='code'>Code</a></li>
    <li><a href='http://delicious.com/stilist' id='links'>Links</a></li>
   </ul>

   <div id='search'>
    <?php get_search_form(); ?>
   </div>
