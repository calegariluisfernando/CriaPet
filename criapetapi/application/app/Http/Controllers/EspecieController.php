<?php

namespace App\Http\Controllers;

use App\Models\Especie;
use App\Services\ErrorMessageService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class EspecieController extends Controller
{
    public function index()
    {
        $especies = Especie::all()->sortByDesc('name');
        return new JsonResponse($especies);
    }

    public function store(Request $request) {
        try {
            $request->validate(['name' =>'required|string|min:3|max:250',]);
            $especie = Especie::create($request->all());
            return new JsonResponse($especie, JsonResponse::HTTP_CREATED);
        } catch (ValidationException $e) {
            return new JsonResponse(['error' => $e->getMessage()], JsonResponse::HTTP_BAD_REQUEST);
        } catch (Exception $e) {
            return new JsonResponse(['error' => ErrorMessageService::handleException($e)], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
