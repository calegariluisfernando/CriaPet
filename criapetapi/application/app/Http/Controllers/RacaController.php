<?php

namespace App\Http\Controllers;

use App\Models\Raca;
use App\Services\ErrorMessageService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class RacaController extends Controller
{
    public function index(Request $request)
    {
        $racas = Raca::with('especie');
        if ($request->has('especie_id')) {
            $racas->where('especie_id', $request->get('especie_id'));
        }

        $racas = $racas->get()->sortBy('name');

        return new JsonResponse($racas);
    }

    public function store(Request $request) {
        try {
            $request->validate([
                'nome' =>'required|string|min:3|max:100',
            ]);
            $raca = Raca::create($request->all());
            return new JsonResponse($raca, JsonResponse::HTTP_CREATED);
        } catch (ValidationException $e) {
            return new JsonResponse(['error' => $e->getMessage()], JsonResponse::HTTP_BAD_REQUEST);
        } catch (Exception $e) {
            return new JsonResponse(['error' => ErrorMessageService::handleException($e)], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
