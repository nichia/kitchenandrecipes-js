// pagination.js

class Pagination {
  constructor(metaData, headerData) {
    // debugger;
    this.current_page = metaData.current_page;
    this.next_page = metaData.next_page;
    this.prev_page = metaData.prev_page;
    this.total_pages = metaData.total_pages;
    this.total_count = metaData.total_count; //duplicate of total
    this.isfirst_page = metaData.isfirst_page;
    this.islast_page = metaData.islast_page;
    this.per_page = parseInt("headerData.perPage");
    this.total = parseInt("headerData.total");
    if (headerData.links !== null && headerData.links !== '') {
      // this.links = headerData.links.split(',').map(item => item.trim());
      // this.links = headerData.links.split(',').reduce((accum, item) => {
      let link_obj = headerData.links.split(',').reduce((accum, item) => {
        // remove quotes then split by 'rel=' to get the keys (first, last, next, prev)
        const kv = item.split('"').join('').split('rel=');
        // kv[0] trim of leading/trailing spaces, remove < and >;
        return { ...accum, ...{ [kv[1]]: kv[0].trim().replace(/[<>;]/g, '') } };
      }, {})
      const order = ["first", "prev", "next", "last"];
      let link_array = Object.entries(link_obj); // convert object to an array
      // sort links according to order array
      this.links = link_array.sort(function(a,b) {
        return order.indexOf( a[0] ) - order.indexOf( b[0] );
      });
      console.log("Pagelinks: ", this.links);
    };
  };
}
