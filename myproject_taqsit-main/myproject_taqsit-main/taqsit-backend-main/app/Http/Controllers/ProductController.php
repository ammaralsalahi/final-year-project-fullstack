<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class ProductController extends Controller
{
    /**
     * --- قسم التاجر (واجهة الويب - Web) ---
     */

    // عرض المنتجات في لوحة تحكم التاجر
    public function index()
    {
        // التاجر يرى منتجاته فقط مع الترتيب من الأحدث للأقدم
        // تم التعديل هنا لاستخدام Guard التاجر الصريح وتجنب خطأ Intelephense
        $products = Product::where('merchant_id', Auth::guard('merchant')->id())->latest()->get();
        return view('merchant.products.index', compact('products'));
    }

    // إضافة منتج جديد من الويب
    public function store(Request $request)
    {
        $request->validate([
            'product_name'      => 'required|string|max:255', // تم تعديل الاسم ليتوافق مع الـ Migration
            'price'             => 'required|numeric|min:1',
            'description'       => 'nullable|string',
            'allow_installment' => 'required|boolean', // تم تعديل الاسم ليتوافق مع الـ Migration
            'image'             => 'required|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        try {
            $data = $request->only(['product_name', 'price', 'description', 'allow_installment']);
            $data['merchant_id'] = Auth::guard('merchant')->id();

            if ($request->hasFile('image')) {
                $data['image'] = $request->file('image')->store('products', 'public');
            }

            Product::create($data);

            return redirect()->back()->with('success', 'تم إضافة المنتج بنجاح ويظهر الآن في تطبيق الزبون!');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'حدث خطأ أثناء إضافة المنتج.');
        }
    }

    // تعديل المنتج من الويب
    public function update(Request $request, $id)
    {
        $product = Product::where('id', $id)->where('merchant_id', Auth::guard('merchant')->id())->firstOrFail();

        $request->validate([
            'product_name'      => 'required|string|max:255',
            'price'             => 'required|numeric|min:1',
            'allow_installment' => 'required|boolean',
        ]);

        $product->update($request->only(['product_name', 'price', 'description', 'allow_installment']));

        if ($request->hasFile('image')) {
            // حذف الصورة القديمة من التخزين
            if ($product->image) { 
                Storage::disk('public')->delete($product->image); 
            }
            $product->image = $request->file('image')->store('products', 'public');
            $product->save();
        }

        return redirect()->back()->with('success', 'تم تحديث بيانات المنتج بنجاح!');
    }

    // حذف المنتج من الويب
    public function destroy($id)
    {
        $product = Product::where('id', operator: $id)->where('merchant_id', Auth::guard('merchant')->id())->firstOrFail();

        // حذف الصورة المرتبطة بالمنتج من القرص
        if ($product->image) { 
            Storage::disk('public')->delete($product->image); 
        }
        
        $product->delete();

        return redirect()->back()->with('success', 'تم حذف المنتج من النظام نهائياً.');
    }

    /**
     * --- قسم الزبون (واجهة الموبايل - Flutter API) ---
     */

    public function getProductsForFlutter()
    {
        // جلب المنتجات المتاحة مع بيانات التاجر
        // تم استخدام select لتقليل حجم البيانات المرسلة للموبايل وتسريع التطبيق
        $products = Product::with('merchant:id,store_name')
    ->whereHas('merchant') // يضمن عدم تعطل التطبيق في حال حذف التاجر
    ->select('id', 'merchant_id', 'product_name', 'price', 'description', 'image', 'allow_installment')
    ->get();
        // تحويل روابط الصور لروابط كاملة (URL) ليتم عرضها في فلاتر مباشرة
        $products->transform(function ($product) {
            $product->image_url = $product->image ? asset('storage/' . $product->image) : asset('images/default-product.png');
            return $product;
        });

        return response()->json([
            'status' => 'success',
            'count'  => $products->count(),
            'data'   => $products
        ], 200);
    }
}