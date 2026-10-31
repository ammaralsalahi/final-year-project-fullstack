<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Product;
use App\Models\Merchant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File; // مهم لحذف الصور القديمة

class MerchantController extends Controller
{
    /**
     * 1. عرض لوحة تحكم التاجر (الإحصائيات)
     */
    public function index()
    {
        $merchant = Auth::guard('merchant')->user();

        $stats = [
            'my_revenue' => $merchant->bank_balance,
            'orders_count' => Order::where('merchant_id', $merchant->id)->count(),
            'pending_payments' => Order::where('merchant_id', $merchant->id)
                                        ->where('status', 'approved')
                                        ->sum('remaining_amount'),
        ];

        $myOrders = Order::where('merchant_id', $merchant->id)
                         ->with(['product', 'user'])
                         ->latest()
                         ->get();

        return view('merchant.dashboard', compact('stats', 'myOrders', 'merchant'));
    }
    

    /**
     * 2. عرض قائمة المنتجات
     */
    public function indexProducts()
    {
        $products = Product::where('merchant_id', Auth::guard('merchant')->id())->get();
        return view('merchant.products.index', compact('products'));
    }

    /**
     * 3. تخزين منتج جديد (مع دعم رفع الصور)
     */
   public function storeProduct(Request $request)
{
    $request->validate([
        'product_name' => 'required|string|max:255',
        'price' => 'required|numeric|min:0',
        'image' => 'nullable|image|mimes:jpeg,png,jpg,webp|max:2048', 
    ]);

    // البدء ببيانات المنتج الأساسية
    $productData = [
        'merchant_id'       => Auth::guard('merchant')->id(),
        'product_name'      => $request->product_name,
        'price'             => $request->price,
        'description'       => $request->description,
        'allow_installment' => $request->has('allow_installment'),
        'image'             => 'default.jpg', // القيمة الافتراضية
    ];

    // التحقق من الملف وإعادة تعيين حقل الصورة إذا وُجد
    if ($request->hasFile('image')) {
        $file = $request->file('image');
        $filename = time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
        $file->move(public_path('images'), $filename);
        
        $productData['image'] = $filename; // تحديث القيمة بالاسم الجديد
    }

    Product::create($productData);

    return back()->with('success', 'تم إضافة المنتج بنجاح');
}

    /**
     * 4. عرض صفحة التعديل
     */
    public function editProduct($id)
    {
        $product = Product::where('id', $id)
                          ->where('merchant_id', Auth::guard('merchant')->id())
                          ->firstOrFail();

        return view('merchant.products.edit', compact('product'));
    }

    /**
     * 5. تحديث المنتج (حل مشكلة التعديل)
     */
    public function updateProduct(Request $request, $id)
    {
        $product = Product::where('id', $id)
                          ->where('merchant_id', Auth::guard('merchant')->id())
                          ->firstOrFail();

        $request->validate([
            'product_name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,webp|max:2048',
        ]);

        // تحديث البيانات الأساسية
        $data = [
            'product_name' => $request->product_name,
            'price' => $request->price,
            'description' => $request->description,
            'allow_installment' => $request->has('allow_installment'),
        ];

        // معالجة الصورة الجديدة إذا وجدت
        if ($request->hasFile('image')) {
            // حذف الصورة القديمة إذا لم تكن الصورة الافتراضية
            if ($product->image && $product->image != 'default.jpg') {
                File::delete(public_path('images/' . $product->image));
            }

            $imageName = time() . '.' . $request->image->extension();
            $request->image->move(public_path('images'), $imageName);
            $data['image'] = $imageName;
        }

        $product->update($data);

        return redirect()->route('merchant.products.index')->with('success', 'تم تحديث بيانات المنتج بنجاح');
    }

    /**
     * 6. حذف المنتج
     */
    public function destroyProduct($id)
    {
        $product = Product::where('id', $id)
                          ->where('merchant_id', Auth::guard('merchant')->id())
                          ->firstOrFail();
        
        // حذف ملف الصورة من السيرفر
        if ($product->image && $product->image != 'default.jpg') {
            File::delete(public_path('images/' . $product->image));
        }

        $product->delete();
        return back()->with('success', 'تم حذف المنتج بنجاح');
    }

    /**
     * 7. دالة الـ API لتطبيق فلاتر
     */
    public function getOrdersApi()
    {
        $merchant = Auth::guard('merchant')->user();
        
        if (!$merchant) {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 401);
        }

        $orders = Order::where('merchant_id', $merchant->id)
                       ->with(['user', 'product'])
                       ->get(); 

        return response()->json([
            'status' => 'success',
            'data' => $orders
        ]);
    }

    /**
     * 8. تسجيل تاجر جديد (بدون كلمة مرور)
     */
    public function register(Request $request)
    {
        // 1. التحقق من البيانات المرسلة من الفورم
        $request->validate([
            'store_name'          => 'required|string|max:255',
            'commercial_reg'      => 'required|string|unique:merchants,commercial_reg',
            'phone'               => 'required|string',
            'bank_account_number' => 'required|string',
        ], [
            'commercial_reg.unique' => 'عذراً، هذا السجل التجاري مسجل لدينا مسبقاً!',
        ]);

        // 2. حفظ بيانات التاجر الجديد
        Merchant::create([
            'store_name'          => $request->store_name,
            'commercial_reg'      => $request->commercial_reg,
            'phone'               => $request->phone,
            'bank_account_number' => $request->bank_account_number,
            // ملاحظة: التاجر يدخل بالسجل التجاري والاسم، لذا لا نحتاج لتشفير كلمة مرور هنا
        ]);

        // 3. إعادة التوجيه لصفحة الدخول مع رسالة نجاح
        return redirect()->route('merchant.login.page')->with('success', 'تم إنشاء حسابك بنجاح! يمكنك الآن تسجيل الدخول.');
    }

}