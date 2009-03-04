<?php get_header(); ?>

  <div class='entry'>
  <?php if (have_posts()) : while (have_posts()) : the_post(); ?>
   <h1><a href='<?php the_permalink(); ?>'><?php the_title(); ?></a></h1>
   <div class='copy'>
    <?php the_content(); ?>
   </div>

   <p class='signoff'>written <a href='<?php the_time('0Y\/F\/j'); ?>'><?php the_time('j F, 0Y'); ?></a>
    • <a href='<?php the_permalink(); ?>#disqus_thread'>Comments</a>
    <a href='<?php the_permalink(); ?>' class='pilcrow' title='Permanent link to this entry'>⁋</a></p>

   <!-- disqus -->
   <script>
    var disqus_url = '<?php the_permalink() ?>';
    var disqus_title = '<?php the_title(); ?>';
   </script>
   <div id='disqus_thread'></div>
   <script src='http://disqus.com/forums/ratafia/embed.js'></script>
   <script>
    //<![CDATA[
    (function() {
     var links = document.getElementsByTagName('a');
     var query = '?';
     for(var i = 0; i < links.length; i++) {
      if(links[i].href.indexOf('#disqus_thread') >= 0) {
       query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
      }
     }
     document.write('<script src="http://disqus.com/forums/ratafia/get_num_replies.js' + query + '"></' + 'script>');
    })();
    //]]>
   </script>
   <!-- /disqus -->
  <?php endwhile; else: ?>
   <h1>Bzzzt!</h1>
   <p>Whatever you were looking for, this isn’t it.</p>
  <?php endif; ?>
  </div>

<?php get_footer(); ?>
