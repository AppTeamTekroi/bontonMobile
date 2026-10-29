class URLConst {
  static const baseURL = "https://tekai.c360.zone/bonton_erp/api/";
  // http://127.0.0.1:8000
  // static const baseURL =
  static const loginURL = "${baseURL}login";

  static const registerURL = "${baseURL}register";

  static const productURL = "${baseURL}product-list";

  static const addBankDetailsURL = "${baseURL}banks";

  // "https://run.mocky.io/v3/473a3519-39c2-4f18-a299-d285d3a0df05";

  static const postProductURL =
      "${baseURL}product-store";
  // "https://run.mocky.io/v3/1a1375a3-ca64-428c-9df2-819e4bada1c5";

  static const postProductCatURL =
      "${baseURL}product-category";

  static const postCustomerURL =
      "${baseURL}customer-store";

  static const getCompanyDetails =
      "${baseURL}company-list";

  static const postCompanyDetails = "${baseURL}company";

  static const getCustomerURL = "${baseURL}customer-list";

/// business-partners
  ///
  ///
  static const getInvoiceURL =
      "https://run.mocky.io/v3/7b1688e8-5eee-4899-a18d-e50159a08ad4";

  static const getBankURL = "${baseURL}bank";

  static const getVendorURL = "${baseURL}vendor";

  static const postVendorURL =
      "${baseURL}vendors-store";

  static const postAddressURL = "${baseURL}address";

  static const addToCartURL = "${baseURL}add-to-cart";

  static const barcodeScanSearchURL =
      "${baseURL}barcode-search";

  static const putCustomerData = "${baseURL}update/";

  static const postOrderPlaced =
      "${baseURL}order-placed";

  static const CartItemURL = "${baseURL}cart-show/";
  static const OrderPlacedURL =
      "${baseURL}orders-list/";
  static const OrderDetailsURL =
      "${baseURL}order-details/";
  static const customerPrescriptionURL =
      "${baseURL}customer-prescriptions/";

  // POST API FOR CART ITEM DELETE
  static const deleteFromCartUrl =
      '${baseURL}cart-item-delete/';

  static const cancelOrderURL =
      '${baseURL}cancel-order/';

  static const createInvoiceURL = '${baseURL}generate-salesinvoice-pdf/';

  static const recordPayment = "${baseURL}payment-records/";
}
